# flickerDemo

### 主題: ###
利用 Flickr API 做出 Demo APP.    

### 基本題: ###
## 功能: ##
> ● 輸入搜尋字串.  
> ● API Response顯示結果.      
## 第一頁 (搜尋輸入頁) ##
> ● 有兩個輸入框.  
> ● 第一個是​搜尋的​輸入匡(Text).  
> ● 第二個是​每頁要呈現的數量​的輸入匡(Per Page).  
> ● 此兩個輸入匡都要填寫，button才可以點擊.  
> ● 不可點擊的button和可點擊的button用不同顏色區別.  
> ● 點擊button會轉跳(push)到第二頁(搜尋結果頁).  
## 第二頁(搜尋結果頁) ##

> ● 使用的API: ​flickr.photos.search.  
> ● API文件: ​https://www.flickr.com/services/api/flickr.photos.search.html.  
> ● PS: Flickr token有時效性.  
  > ● 把第一頁的Text和Per Page等輸入值帶入去做API Request，參數為​text、​per_page.  
> ● 此頁為可無限滑動的頁面.  
> ● 會顯示圖片(photo)，與標題.  
### 進階題:(可不做) ###
## 功能: ##   
> ● 我的最愛   
> ● 本地儲存 我的最愛頁面.  
> ● tabbar多一個分頁.  
> ● 在搜尋結果頁的每一個cell 加上加入收藏的按鈕.  
> ● 當按加入收藏，到我的最愛頁面，可以看到該photo被加入.  
> ● 重開APP依然可以看到被加入的收藏.  
