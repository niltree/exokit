#!/bin/sh

if [ -z "${PFX_KEY}" ]
then
  cp appdmg.json /tmp
  appdmg /tmp/appdmg.json niltree-macos-x64.dmg
else
  security create-keychain -p nopassword build.keychain
  security default-keychain -s build.keychain
  security unlock-keychain -p nopassword build.keychain
  security set-keychain-settings -t 3600 -u build.keychain
  security import codesign-macos.pfx -k build.keychain -P "${PFX_KEY}" -A
  security set-key-partition-list -S apple-tool:,apple: -s -k nopassword build.keychain
  find /tmp/Niltree.app -type f | xargs -n 1 codesign --force --verify --verbose --sign "7C22D41BA5AB743D3E47D543F6B27FE2FC720412"
  codesign --force --verify --verbose --sign "7C22D41BA5AB743D3E47D543F6B27FE2FC720412" /tmp/Niltree.app
  cp appdmg-codesign.json /tmp
  appdmg /tmp/appdmg-codesign.json niltree-macos-x64.dmg
fi
