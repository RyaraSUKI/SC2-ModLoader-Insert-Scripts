## ModLoader Simple Using Bat By: RyaraSUKI

欢迎使用SugarCube2 ModLoader注入脚本！在使用前，请确保你已经阅读并理解了使用说明中的所有内容！

[⭐]什么是ModLoader？
SugarCube2 ModLoader是一个适用于方糖的模组加载管理框架，由
[Lyoko-Jeremie](https://github.com/Lyoko-Jeremie)
及该仓库的
[贡献者们](https://github.com/Lyoko-Jeremie/sugarcube-2-ModLoader/graphs/contributors)
共同创作，让我们感谢他们对Twine社区做出的贡献！

[⭐]为什么使用ModLoader？
通过ModLoader，可以实现的功能包括注入Mod以替换段落、增加或替换js脚本/css样式、通过i18n实现多语言等。

添加ModLoader，无疑为你的Twine项目增加了无限的可能，比如创造一个可自由扩展的mod社区，为你的项目实现多语言，为你的项目实现外置资源包加载以缩短文件加载时间和美化扩展……

甚至在完成一个大版本发布后，一些小内容的修改补充或漏洞的修复都可以直接通过发布mod包来进行补丁式的更新。

现在通过脚本简化注入过程，可以让人人都为自己的Twine SugarCube2项目添加ModLoader框架，希望有一天，Twine社区可以因为这个强大的框架，而变得更加繁荣（

[⭐]这个脚本是干什么的？
通过ModLoader提供的jQuery启动方法修改最新版SugarCube2的注入点，我们使得这个强大的框架可以在所有以SugarCube2为故事格式的项目上运行。
但是，由于学习基础要求过高，使得一些项目不能方便的接入这个强大的模组加载框架，为此，我简单的编写了一个脚本，并直接把需要用到的环境下载整合到本地，解压即用，运行脚本即可对Twine发布版HTML文件进行快速简单的ModLoader注入。
这个脚本只包含了最基本的ModLoader功能，并且是按一定格式进行运行的，因此只适用于不了解命令行操作情况下的快速便捷注入，如果你有HTML以及命令行相关基础，根据
[语雀文档](https://www.yuque.com/u45355763/twine)和
[ModLoader文档](https://github.com/Lyoko-Jeremie/sugarcube-2-ModLoader/blob/master/README.md)
自行编译是最妥当的。

[⭐]修改版故事格式2.37.3版本的
[发布地址](https://github.com/RyaraSUKI/sugarcube-2-modloader-orig/releases/tag/v2.37.3-modloader)

[⭐]我该如何使用？
[⚠️先行条件]：
请确保把这个脚本加入了杀毒软件的白名单或直接暂时关闭杀毒软件，否则脚本可能被误杀，运行不成功。
（❤️请放心，这个脚本以及[所有用到的相关组件]全部都是[开源]的，透明安全，无毒无害）
[详细步骤]：
1. 准备你的项目的[发布文件]

- 打开Twine，进入你项目的编辑界面，选择"构建"选项卡，点击"发布到文件"或"导出为twee"，这里推荐选择["导出为twee"]，否则直接发布为HTML文件将会让脚本对你的HTML执行反编译为twee再重新编译，过程重复且繁琐。
- 如果可以，请将起始段落（故事从这里开始）名字改为"Start"避免脚本自动化替换误换其他内容，因为ModLoader的Gui只会在名为"Start"的段落显示入口按钮

2. 运行[脚本]

- 得到了发布文件后，记住这个文件的位置，最好把它拖到桌面上，然后这个文件夹里双击"运行脚本.bat"运行，（确保它有足够的权限修改文件），随后，根据弹出的窗口上的提示进行操作，得到带ModLoader的新HTML文件。

3. 测试[ModLoader]

- 用你的浏览器打开新得到的HTML，观察是否有类似日志的东西在加载转圈时显示，待全部加载完成后，你可以发现你的游戏主界面（Start）左下角处有一个被虚线框着的["模组加载器+版本号"]按钮，这就证明ModLoader真的被成功注入了，恭喜！

- 接下来，请打开这个文件夹里的"testmod"文件夹，根据里面的说明编写一个测试的mod来测试ModLoader的可运行性。
    
[⭐]LICENSE相关

这个脚本完全是针对于对命令行没有任何接触的情况而设计的，因此在本地直接引用了"tweego", "node", "modloader"的库，省去下载引入的过程。
除对 "tweego/storyformats/twone2/sugarcube-2/format.js" 和 "modloader/modList.json" 进行了一定的修改外，其余组件均保持最新发布版内容未做改动，整个包皆根据各自的许可证书以相同方式共享。

[❤️感谢这三个开源项目的贡献者们！❤️]

## 常见问题：
- 有日志显示，但找不到gui打开按钮，按Alt+M看是否能打开，这是因为脚本不能替换你的起始段落名为Start，ModLoader找不到导致的
- mod无法加载，请检查替换的段落名后面是否完全删去花括号里的数据

❤️ RyaraSUKI 2025.4 ⭐