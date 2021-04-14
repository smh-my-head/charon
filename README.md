# Charon
The ferryman to Hell (aka CAD version control). Provides integration with git
for SolidWorks parts and assemblies.

## Usage

Add this repo as a submodule and then run `./sldworks-git-tools/setup.sh` from
git bash. You can then use git as normal, but `git diff` and `git merge` will
have added sugar.

You will also need to enable *SOLIDWORKS Utilities* at startup, you can do this
by navigating (in SolidWorks) to *Tools->Add-Ins* and checking the box for
startup next to *SOLIDWORKS Utilities*

## Note

There are a lot of possible edge cases so this could still be a little rough
around the edges. Please open an issue if anything isn't working quite as
expected, or if there are ways that you think we could improve your workflow
any more.
