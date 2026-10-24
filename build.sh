#!/bin/bash
set -e

swift package --swift-sdk swift-6.4.1-RELEASE_wasm js

rm -rf docs && mkdir docs
cp -R .build/plugins/PackageToJS/outputs/Package/. docs/
rm -rf docs/node_modules

cp style.css docs/
sed 's|\./\.build/plugins/PackageToJS/outputs/Package/|./|g' index.html >docs/index.html

touch docs/.nojekyll
