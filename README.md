# EzDida

EzDida是一个基于滴答清单的后台服务,方便通过滴答清单的收集箱快速添加笔记到Workflowy。

## 使用效果

手机上通过滴答清单来快速收集

1.通过滴答清单的微信机器热收集笔记

![](https://yupic.oss-cn-shanghai.aliyuncs.com/telegram-cloud-photo-size-5-6260400749796245667-y.jpg?x-oss-process=image/resize,w_200,limit_0)

2.通过分享到滴答清单App来收集笔记

![](https://yupic.oss-cn-shanghai.aliyuncs.com/telegram-cloud-photo-size-5-6260400749796245666-y.jpg?x-oss-process=image/resize,w_200,limit_0)

电脑上通过WF来批量整理

![](https://yupic.oss-cn-shanghai.aliyuncs.com/202406021739730.png?x-oss-process=image/resize,w_600,limit_0)

## 使用说明

1-添加.env配置文件

```
DIDA_ACCESS_TOKEN="3ad46d12-a0d6-454d-8ccc-XXXXXXXXXXXX"
DIDA_INBOX_ID="inbox101059XXXX"
WF_SESSION_ID="bza32axq7bbzt9w5h1k6b163v017XXXX"
WF_INBOX_NAME="滴答清单-Inbox"
```

2-运行docker

```
docker-compose up -d --build
```

## 4个配置参数的说明

### DIDA_ACCESS_TOKEN和DIDA_INBOX_ID

1.登录[滴答清单网页版](https://dida365.com/webapp)
2.允许[OAtuth授权: dida-sync](https://dida365.com/oauth/authorize?scope=tasks:write%20tasks:read&client_id=13TIYIw0ik1FxqLREs&state=Ups0YwpHwWF1yoct&redirect_uri=https://fastapi.fishyer.com/dida/redirect_uri&response_type=code )

![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405211959727.png)

点击允许以后，可以获取一个类似的json数据，其中access_token和inbox_id就是我们需要的两个参数:
```
{
  "state": "Ups0YwpHwWF1yoct",
  "code": "hsisEo",
  "access_token": "3ad46d12-a0d6-454d-8ccc-e3bbceXXXXXX",
  "inbox_id": "inbox1010XXXXXX"
}
```
因为滴答清单的API本身是没有获取收集箱ID的接口，所以这里会自动在滴答清单的收集箱中添加一个auto-create-task的任务，通过这个任务的projectId来获取收集箱ID。

### WF_SESSION_ID

登录Workflowy，打开浏览器的开发者工具，通过Application->Storage->Cookie，找到https://workflowy.com 的cookie，再找到名为"SESSIONID"的键值对，复制其值。类似：bza32axq7bbzt9w5XXXXXXXXYYYYYYYY，保存下来
![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405212006101.png)

### WF_INBOX_NAME

这个就是滴答清单的收集箱任务，保存到Workflowy中的一级节点的名称，默认是"滴答清单-Inbox"，可以根据自己的需求修改。在Workflowy的一级节点中，找到就直接追加子节点，找不到则新建该节点再添加子节点。