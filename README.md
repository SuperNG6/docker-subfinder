# Docker SubFinder 自动刮削字幕器

### 自动刮削媒体文件字幕，打开容器后开始遍历媒体文件，遍历结束后休眠，之后每隔2小时遍历一次

Docker Hub：https://hub.docker.com/r/superng6/subfinder

GitHub：https://www.github.com/SuperNG6/docker-subfinder

博客：https://sleele.com/2020/04/09/subfinder


 本镜像根据：ausaki的 https://github.com/ausaki/subfinder 字幕查找器制作
 具体的参数请参照subfinder的readme进行修改  

 1、配置文件`subfinder.json`位于`/config/subfinder.json`，请根据的你情况自行修改  
 ~~2、计划任务配置`subfinder-cron`位于`/config/subfinder-cron`，请根据的你情况自行修改~~   
 2、去掉cron，改用sleep，降低使用难度，防止cron失效。现在设置更简单，env里设置`TASK`时间即可  
 `s 为秒，m 为 分钟，h 为小时，d 为日数`，默认2小时执行一次任务，例`TASK=2h`
 		
 
````
{
   "exts": ["ass", "srt"],
   "method": ["shooter", "zimuzu", "zimuku"],
   "video_exts": [".mp4", ".mkv", ".iso"],
   "api_urls": {
      "zimuku": "http://www.zimuku.la/search",
      "zimuzu": "http://www.zmz2019.com/search",
      "zimuzu_subtitle_api_url": "http://got001.com/api/v1/static/subtitle/detail"
   }
}
````


 # 官方说明文档
 <details>
   <summary>官方说明文档</summary>

 | 参数              | 含义                                                                                               | 必需                                               |
| ----------------- | -------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| `-l, --languages` | 指定字幕语言，可同时指定多个。每个字幕查找器支持的语言不相同。具体支持的语言请看下文。             | 否，subfinder 默认会下载字幕查找器找到的所有字幕。 |
| `-e, --exts`      | 指定字幕文件格式，可同时指定多个。每个字幕查找器支持的文件格式不相同。具体支持的文件格式请看下文。 | 否，subfinder 默认会下载字幕查找器找到的所有字幕。 |
| `-m,--method`     | 指定字幕查找器，可同时指定多个。                                                                   | 否，subfinder 默认使用 shooter 查找字幕。          |
| `--video_exts`     | 视频文件的后缀名（包括.，例如.mp4）                                    | 否          |
| `--repeat` | 重复查找字幕，即使本地字幕已存在，默认False。 | 否 |
| `--exclude` | 排除匹配模式的文件或目录，类似于shell的文件匹配模式。详情见下文 | 否 |
| `--api_urls` | 指定字幕搜索器的API URL。详情见下文 | 否 |
| `-c,--conf` | 配置文件                                                                   |否，SubFinder默认从~/.subfinder.json读取。|
| `-s,--silence` | 静默运行，不输出日志                                                                   | 否 |
| `--debug` | 调试模式，输出调试日志                                                                   | 否 |
| `-h,--help` | 显示帮助信息                                                                   | 否|

- `--exclude`, 支持的匹配模式类似于shell，`*` 匹配任意长度的字符串，`?` 匹配一个字符，`[CHARS]`匹配CHARS中的任一字符。例如：

   - 排除包含`abc`的目录：`--exclude '*abc*/'`。注意添加单引号，防止shell对其进行扩展。

   - 排除包含`abc`的文件：`--exclude '*abc*'`。注意和上个例子的区别，匹配目录时结尾有`/`目录分隔符，匹配文件则没有。


- `--api_urls`

   [字幕库](http://www.zimuku.la)的链接不太稳定，有时候会更换域名，因此提供`--api_urls`选项自定义API URL，以防域名或链接变动。

   `--api_urls`只接收JSON格式的字符串。

   获取正确的API URL的方法：

   - 字幕库的API一般形如 http://www.zimuku.la/search， 这个URL就是网页端“搜索”功能的URL。

   - 字幕组的API一般形如 http://www.zmz2019.com/search， 这个URL同样是网页端“搜索”功能的URL。

   - 射手网的API比较稳定，一般不会变动。

   配置示例：

   ```
   {
      // 设置字幕库的API
      "zimuku": "http://www.zimuku.la/search",
      // 设置字幕组的API
      "zimuzu": "http://www.zmz2019.com/search",
      // 设置字幕组获取字幕下载链接的API
      "zimuzu_subtitle_api_url": "http://got001.com/api/v1/static/subtitle/detail"
   }
   ```

支持的语言和文件格式：

| 字幕查找器 | 语言                                | 文件格式       |
| ---------- | ----------------------------------- | -------------- |
| shooter    | ['zh', 'en']                        | ['ass', 'srt'] |
| zimuku     | ['zh_chs', 'zh_cht', 'en', 'zh_en'] | ['ass', 'srt'] |
| zimuzu     | ['zh_chs', 'zh_cht', 'en', 'zh_en'] | ['ass', 'srt'] |

语言代码：

| 代码   | 含义               |
| ------ | ------------------ |
| zh     | 中文，简体或者繁体 |
| en     | 英文               |
| zh_chs | 简体中文           |
| zh_cht | 繁体中文           |
| zh_en  | 双语               |

### 配置文件

配置文件是JSON格式的，支持命令行中的所有选项。命令行中指定的选项优先级高于配置文件的。

配置文件中的key一一对应于命令行选项，例如`-m，--method`对应的key为`method`。

示例：

```json
{
   "exts": ["ass", "srt"],
   "method": ["shooter", "zimuzu", "zimuku"],
   "video_exts": [".mp4", ".mkv", ".iso"],
   "api_urls": {
      "zimuku": "http://www.zimuku.la/search",
      "zimuzu": "http://www.zmz2019.com/search",
      "zimuzu_subtitle_api_url": "http://got001.com/api/v1/static/subtitle/detail"
   }
}
```

</details>

# 本镜像的一些特点
- 做了usermapping，使用你自己的账户权限来运行，这点对于群辉来说尤其重要
- 支持选择执行检查完全部文件后是否后退出容器（默下载完成全部字幕后自动退出容器）
- 镜像体积巨大200M，无法继续压缩镜像体积
- base images使用ubuntu cloud (仅20M)，alpine下缺少部分库


# Architecture
只有x86-64版，arm64版编译失败，可能有些库没有
| Architecture | Tag            |
| ------------ | -------------- |
| x86-64       | latest         |


# Changelogs

## 2020/04/11

  	1、去掉cron，改用sleep，降低使用难度，防止cron失效。现在设置更简单，env里设置`TASK`时间即可  
  	2、 `s 为秒，m 为 分钟，h 为小时，d 为日数`，默认2小时执行一次任务，例`TASK=2h`


## 2020/04/10

  	1、update subfinder 1.1.2
  	2、根据作者的意见，删除指定语言参数，默认全部语言
  	3、修复zimuzu解析问题
  	4、增加了手动选择执行间隔选项,`/config/subfinder-cron`，cron表达式

## 2020/04/09

	1、update subfinder 1.1.1
  	2、更改执行计划为，打开容器后开始遍历媒体文件，遍历结束后休眠，之后每隔一小时遍历一次
  	3、更改媒体挂载卷为``/media``

## 2020/03/05

	1、first commit


# Document

## 挂载路径
``/config`` ``/media``

![4zb8Mq](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/4zb8Mq.png)
![2HgLQ4](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/2HgLQ4.png)

## 关于群晖

 <details>
   <summary>群晖DSM权限设置</summary>

群晖用户请使用你当前的用户SSH进系统，输入 ``id 你的用户id`` 获取到你的UID和GID并输入进去

![nwmkxT](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/nwmkxT.jpg)
![1d5oD8](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/1d5oD8.jpg)
![JiGtJA](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/JiGtJA.jpg)

### 权限管理设置
对你的``docker配置文件夹的根目录``进行如图操作，``你的下载文件夹的根目录``进行相似操作，去掉``管理``这个权限，只给``写入``,``读取``权限
![r4dsfV](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/r4dsfV.jpg)

 </details>

## Linux

输入 ``id 你的用户id`` 获取到你的UID和GID，替换命令中的PUID、PGID

__执行命令__
````
docker create \
  --name=subfinder \
  -e PUID=1026 \
  -e PGID=100 \
  -e TZ=Asia/Shanghai \
  -e TASK=2h \
  -v /path/to/appdata/config:/config \
  -v /path/to/libraries:/media \
  superng6/subfinder
  ````
docker-compose  
  ````
  version: "3"
services:
  aria2:
    image: superng6/subfinder
    container_name: subfinder
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Asia/Shanghai
      - TASK=2h
    volumes:
      - /path/to/appdata/config:/config
      - /path/to/libraries:/media
````

# Preview
![nQxPak](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/nQxPak.png)
![j3geSM](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/j3geSM.png)
![MQTiHZ](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/MQTiHZ.png)
