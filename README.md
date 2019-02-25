# OpenSTF mitamae

## Usage

```sh
./install.sh -n  # dry-run
./install.sh     # apply
```

## First things to do
rethinkdb password is not registered.
Please register the initial password with the following command.

```
docker run --rm -v /srv/rethinkdb:/data rethinkdb:2.3 rethinkdb --initial-password yourBrandNewKey
```
Register the registerd password in the `nodes/openstf.yml` file.


## Install with one line of script

```sh
bash -c "`curl -fsSL https://gist.githubusercontent.com/ManabuSeki/a493ac56866517d356675492a3cc0e18/raw/bcea0d76ee30436e3c8302868a1d25dd3ad527a4/setup_openstf`"
```
