# Git
Version control system

## Configuration
Set username and email
```
git config --global user.name "USERNAME"
git config --global user.email "EMAIL"
```

Save credentials in cache for ~1 year
```
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=315336000'
```