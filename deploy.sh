#!/bin/bash
# Deploy First Light to its ONE canonical Netlify site.
# Always pass --site explicitly: a bare `netlify deploy` has, in the past,
# failed to resolve the folder link and silently CREATED A NEW SITE instead.
set -e
SITE_ID="537e2d7e-04fa-46bb-8331-bfddc132b5ad"   # first-light-daily.netlify.app
cd "$(dirname "$0")"

# bump the service-worker cache version so phones pick up the change
node -e '
  const fs=require("fs"), p="sw.js";
  let s=fs.readFileSync(p,"utf8");
  s=s.replace(/first-light-v(\d+)/g,(_,n)=>"first-light-v"+(+n+1));
  fs.writeFileSync(p,s);
  console.log("sw cache ->", s.match(/first-light-v\d+/)[0]);
'

npx --yes netlify-cli deploy --dir=. --prod --site="$SITE_ID"
echo
echo "Live: https://first-light-daily.netlify.app"
