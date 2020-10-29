# MultiselectDownloadTable

* 在 TableView 中多选，使用 AFNetWorking 对选中的数据进行下载，存储到新建的沙盒文件夹内
* 通过 UITextField 内获取的并发数，使用 dispatch_semaphore 控制下载的最大并发数
* 把获取的JSON数据存入 Realm 中
