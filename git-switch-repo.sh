# 用于git迁移仓库
git branch -r | grep -v '>' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
git fetch --all
git pull --all