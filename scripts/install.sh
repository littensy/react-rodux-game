rm -rf packages
wally install
rojo sourcemap --output sourcemap.json
wally-package-types --sourcemap sourcemap.json Packages/
mv Packages packages
