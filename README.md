# FSEmptyDataSet
一款简易的页面空白占位小组件。

## 版本更新
##### 1.0.3
* 修正：在 customView 无效的时候判断 UIImage 是否有效，如有效则设置显示 UIImage。

##### 1.0.2
* 可以自定义 view 替代顶部 UIImageView 了，比如自定义一个 LoadingView 之类的，可参考使用例子的第一个图。

## 使用方式

只要引入头文件 `FSEmptyDataSet` 之后遵守对应的 `FSEmptyViewDelegate` 和 ` FSEmptyViewDataSource` ，然后实现对应的代理方法和数据源方法即可。

UITableView 设置方法只需要两句代码即可：

```objective-c
self.tableView.fs_emptyDelegate = self;
self.tableView.fs_emptyDataSource = self;
```

UICollectionView 设置方法同样只需要两句代码即可：

```objective-c
self.collectionView.fs_emptyDelegate = self;
self.collectionView.fs_emptyDataSource = self;
```



## 使用例子

<img src="https://i.loli.net/2018/11/04/5bdeb7f8e6931.gif" width="200px;"/> <img src="https://i.loli.net/2018/11/04/5bdea55d3e883.png" width="200px;"/> 

<img src="https://i.loli.net/2018/11/04/5bdea55ee502d.png" width="200px;"/> <img src="https://i.loli.net/2018/11/04/5bdea55d3e924.png" width="200px;"/>

## 安装要求

Xcode9.0+, iOS8.0+

## 安装方式

* `FSEmptyDataSet` 支持使用 `CocoaPods` 引入，在 `podfile` 文件中添加以下代码：

    ```ruby
    pod 'FSEmptyDataSet', '~> 1.0.3'
    ```

* 也可以直接引入代码，下载项目后把 `FSEmptyDataSet/Classes` 路径下的文件拖入你的项目中即可。

## 开源许可证

`FSEmptyDataSet` 使用 MIT 许可证开源，详情可查阅 `LICENSE` 文件。


