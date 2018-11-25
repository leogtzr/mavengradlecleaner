# mavengradlecleaner
Little script to clean up maven and gradle projects.

## Usage
```
./mavengradlecleaner.sh
```

## Important

The usage of locate (mlocate) is not mandatory, you can substitute that with the following command if you want:

```
find / -type f -name 'pom.xml' -or -name 'build.gradle'
```
but running _sudo updatedb_ before this script is always a good idea :smiley: