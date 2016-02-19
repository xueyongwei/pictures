# pictures
横向tableView

tableView横向滚动小demo。
需要注意的是此处tableVeiw所在VC未使用autolayout，若使用了则此方法不可行。
在autoresizing中，旋转后会以原视图中心为原点旋转，旋转后不改变大小。
旋转后的再设置frame。

旋转了tableView后还需要反向旋转cell才能看到正向的效果。

