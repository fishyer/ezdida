1. npx install husky
2. 复制.husky(除了刚才生成的_文件夹)和.gitea文件夹到项目中
3. 修改下列4个文件中: 
- .gitea/workflows/ssh-remote-command.yml里面的env常量和ssh服务器地址
- .husky/build_config.yaml里面的初始版本号