# Docker SubFinder 自动刮削字幕器

### 自动刮削媒体文件字幕，打开容器后开始遍历媒体文件，遍历结束后休眠，之后每天遍历一次

Docker Hub：https://hub.docker.com/r/superng6/subfinder

GitHub：https://www.github.com/SuperNG6/docker-subfinder

博客：https://sleele.com/2020/04/09/subfinder


 本镜像根据：ausaki的 https://github.com/ausaki/subfinder 字幕查找器制作
 具体的参数请参照subfinder的readme进行修改  

 1、配置文件`subfinder.json`位于`/config/subfinder.json`，请根据的你情况自行修改  
 2、env里设置`TASK`时间即可  
 `s 为秒，m 为 分钟，h 为小时，d 为日数`，默认`1d`执行一次任务，例`TASK=1d`
 		
 
  ```
  {
    // 设置字幕库的搜索 API
    "zimuku": "http://www.zimuku.la/search",
    // 设置字幕组的搜索 API
    "zimuzu": "http://www.zmz2019.com/search",
    // 设置字幕组获取字幕下载链接的 API, 注意不包含域名
    "zimuzu_api_subtitle_download": "/api/v1/static/subtitle/detail",
    // 设置 SubHD 的搜索 API
    "subhd": "https://subhd.tv/search",
    // 设置 SubHD 获取字幕下载链接的 API, 注意不包含域名
    "subhd_api_subtitle_download": "/ajax/down_ajax",
    // 设置 SubHD 获取字幕预览的 API, 注意不包含域名
    "subhd_api_subtitle_preview": "/ajax/file_ajax"
  }
  ```


 # 官方说明文档
 <details>
   <summary>官方说明文档</summary>

 
## 使用方法

### 命令行

- 使用默认字幕查找器（shooter）查找单个视频的字幕：

  `subfinder /path/to/videofile`

- 使用默认字幕查找器（shooter）查找目录下（递归所有子目录）所有视频的字幕：

  `subfinder /path/to/directory_contains_video`

- 使用指定的字幕查找器查找字幕，例如 zimuku：

  `subfinder /path/to/videofile -m zimuku`

- 同时使用多个字幕查找器查找字幕

  `subfinder /path/to/videofile -m shooter zimuku`

  当指定多个字幕查找器时，subfinder 会依次尝试每个字幕查找器去查找字幕，只要有一个字幕查找器返回字幕信息，则不再使用后面的字幕查找器查找字幕。

  ** 注意：** 如果指定了多个字幕查找器，请不要指定 `languages` 参数，否则可能会出现 `LanguageError` 错误（因为每个 `SubSearcher` 支持的语言可能不相同）。

常用参数说明（详细的参数信息请查看 `subfinder -h`）：

| 参数              | 含义                                                                                               | 必需                                               |
| ----------------- | -------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| `-l, --languages` | 指定字幕语言，可同时指定多个。每个字幕查找器支持的语言不相同。具体支持的语言请看下文。             | 否，subfinder 默认会下载字幕查找器找到的所有字幕。 |
| `-e, --exts`      | 指定字幕文件格式，可同时指定多个。每个字幕查找器支持的文件格式不相同。具体支持的文件格式请看下文。 | 否，subfinder 默认会下载字幕查找器找到的所有字幕。 |
| `-m,--method`     | 指定字幕查找器，可同时指定多个。                                                                   | 否，subfinder 默认使用 shooter 查找字幕。          |
| `-k, --keyword`   | 手动搜索关键字. 当 SubFinder 使用本身的关键字无法搜索到字幕时, 可以通过这个参数手动指定关键字.     | 否                                                 |
| `--video_exts`    | 视频文件的后缀名（包括.，例如. mp4）                                                               | 否                                                 |
| `--ignore`        | 忽略本地已有的字幕强行查找字幕. 注意: 这可能会覆盖本地已有的字幕. 默认 False。                     | 否                                                 |
| `--exclude`       | 排除文件或目录，支持类似于 shell 的文件匹配模式。详情见下文                                        | 否                                                 |
| `--api_urls`      | 指定字幕搜索器的 API URL。详情见下文                                                               | 否                                                 |
| `-c, --conf`      | 配置文件                                                                                           | 否，SubFinder 默认从~/.subfinder.json 读取。       |
| `-s,--silence`    | 静默运行，不输出日志                                                                               | 否                                                 |
| `--debug`         | 调试模式，输出调试日志                                                                             | 否                                                 |
| `-h,--help`       | 显示帮助信息                                                                                       | 否                                                 |

- `--exclude`, 支持的匹配模式类似于 shell，`*` 匹配任意长度的字符串，`?` 匹配一个字符，`[CHARS]` 匹配 CHARS 中的任一字符。例如：

   - 排除包含 `abc` 的目录：`--exclude '*abc*/'`。注意添加单引号，防止 shell 对其进行扩展。

   - 排除包含 `abc` 的文件：`--exclude '*abc*'`。注意和上个例子的区别，匹配目录时结尾有 `/` 目录分隔符，匹配文件则没有。


- `--api_urls`

  [字幕库](http://www.zimuku.la) 的链接不太稳定，有时候会更换域名，因此提供 `--api_urls` 选项自定义 API URL，以防域名或链接变动。

  `--api_urls` 只接收 JSON 格式的字符串。

  获取正确的 API URL 的方法：

  - 字幕库的 API 一般形如 http://www.zimuku.la/search， 这个 URL 就是网页端 “搜索” 功能的 URL。

  - 字幕组的 API 一般形如 http://www.zmz2019.com/search， 这个 URL 同样是网页端 “搜索” 功能的 URL。

  - SubHD 的 API 一般形如 https://subhd.tv/search. 

  - 射手网的 API 比较稳定，一般不会变动。

  **如果发现字幕网站的 API URL 发生改变, 欢迎提交 issue.**

  配置示例：

  ```
  {
    // 设置字幕库的搜索 API
    "zimuku": "http://www.zimuku.la/search",
    // 设置字幕组的搜索 API
    "zimuzu": "http://www.zmz2019.com/search",
    // 设置字幕组获取字幕下载链接的 API, 注意不包含域名
    "zimuzu_api_subtitle_download": "/api/v1/static/subtitle/detail",
    // 设置 SubHD 的搜索 API
    "subhd": "https://subhd.tv/search",
    // 设置 SubHD 获取字幕下载链接的 API, 注意不包含域名
    "subhd_api_subtitle_download": "/ajax/down_ajax",
    // 设置 SubHD 获取字幕预览的 API, 注意不包含域名
    "subhd_api_subtitle_preview": "/ajax/file_ajax"
  }
  ```

支持的语言和文件格式：

| 字幕查找器 | 语言                                | 文件格式       |
| ---------- | ----------------------------------- | -------------- |
| shooter    | ['zh', 'en']                        | ['ass', 'srt'] |
| zimuku     | ['zh_chs', 'zh_cht', 'en', 'zh_en'] | ['ass', 'srt'] |
| zimuzu     | ['zh_chs', 'zh_cht', 'en', 'zh_en'] | ['ass', 'srt'] |
| subhd      | ['zh_chs', 'zh_cht', 'en', 'zh_en'] | ['ass', 'srt'] |

语言代码：

| 代码   | 含义               |
| ------ | ------------------ |
| zh     | 中文，简体或者繁体 |
| en     | 英文               |
| zh_chs | 简体中文           |
| zh_cht | 繁体中文           |
| zh_en  | 双语               |

### 配置文件

配置文件是 JSON 格式的，支持命令行中的所有选项。命令行中指定的选项优先级高于配置文件的。

配置文件中的 key 一一对应于命令行选项，例如 `-m，--method` 对应的 key 为 `method`。

示例：

```json
{
  "languages": ["zh", "en", "zh_chs"],
  "exts": ["ass", "srt"],
  "method": ["shooter", "zimuzu", "zimuku"],
  "video_exts": [".mp4", ".mkv", ".iso"],
  "exclude": ["excluded_path/", "*abc.mp4"],
  "api_urls": {
    // 设置字幕库的搜索 API
    "zimuku": "http://www.zimuku.la/search",
    // 设置字幕组的搜索 API
    "zimuzu": "http://www.zmz2019.com/search",
    // 设置字幕组获取字幕下载链接的 API, 注意不包含域名
    "zimuzu_api_subtitle_download": "/api/v1/static/subtitle/detail",
    // 设置 SubHD 的搜索 API
    "subhd": "https://subhd.tv/search",
    // 设置 SubHD 获取字幕下载链接的 API, 注意不包含域名
    "subhd_api_subtitle_download": "/ajax/down_ajax",
    // 设置 SubHD 获取字幕预览的 API, 注意不包含域名
    "subhd_api_subtitle_preview": "/ajax/file_ajax"
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
## 2020/07/15

   1、更新subfinder v1.1.4

- 将参数 `--repeat` 修改为 `--ignore`.

- 添加新参数 `-k, --keyword`.

- 支持 SubHD. SubHD 在下载字幕时经常弹出验证码, 无法通过正常的API获取到字幕的下载链接, 目前的做法是通过 SubHD 的字幕预览功能获取字幕.

- 修复一些 bug.

- 注意: 配置文件中的一些配置项修改了名字, 具体查看官方配置文档.

## 2020/04/19

   1、上一个版本有问题，回退 commit@b735680240cf0b2f2734f9d0e9af49a77b81620e

## 2020/04/16

   1、取消定时执行任务，使用inotifywait文件监控 @fanyinghao  
   2、启动容器时全局遍历一次媒体文件
   3、增加启动容器时是否遍历媒体文件选项`BS=true`默认开启

## 2020/04/14

   1、根据广大人民群众的意见，修改默认参数为一天执行一次`1d`

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
