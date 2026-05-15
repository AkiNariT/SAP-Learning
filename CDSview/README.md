## 🔶编辑器 <br>
用Eclipes来写！<br>
上学时嫌弃的编辑器，此时看来是那么的扎实惹人喜爱。<br>

下载的Eclipes是不带有ABAP编码的，此时即便新建程序也没有ABAP选项。<br>
因此此时要做的是先准备ADT插件。<br>

<details>
<summary>下载ADT插件</summary>
🔹顶部菜单<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Help<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;→ Install New Software...<br>
<br>
🔹然后在 Work with: 里面输入：https://tools.hana.ondemand.com/latest<br>
<br>
🔹输入后等待加载。加载完成后可以看到:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ABAP Development Tools<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SAP HANA Tools<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BW Modeling Tools<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;学习CDS VIEW时，只选择ABAP Development Tools即可。

🔹一直next。如果出现Trust / 安全确认，全选即可，直到出现Restart Now。

</details>

下载完ADT插件后，接下来就是创建第一个CDS View的操作了。

## 🔶CDS 种类 <br>


## 🔶CDS View流程 <br>
<details>
  <summary>Eclipes和SAP建立联系</summary>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在新建ABAP程序时，是可以看到环境的。红色掩盖的其实就是环境信息。<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="778" height="817" alt="image" src="https://github.com/user-attachments/assets/c81ca60b-152a-41e8-a64a-1f0e404f4e7e" /><br>
  <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;下一步就会进到环境相关设定了，账号密码语言。<br>
  <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="778" height="832" alt="image" src="https://github.com/user-attachments/assets/fcbf6269-104e-4629-8104-d2b65f918acf" /> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="267" height="166" alt="image" src="https://github.com/user-attachments/assets/244c0370-f536-41d4-bcb5-47aec867b199" />
 <br>
 <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;这就算成功建立联系了。
</details>

<details>
  <summary>如何新建一个CDS View</summary>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在Favourite Packages中右键选择Add a package...<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="383" height="201" alt="image" src="https://github.com/user-attachments/assets/2c4b6203-c683-470e-bedf-cf04474f65bd" /><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在红框输入想要添加的Package  <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="733" height="617" alt="image" src="https://github.com/user-attachments/assets/49de0117-c28a-4f06-99aa-7b9b719fd90b" /><br>

 <br> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;然后在Package加入自己的CDS View程序。<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="963" height="124" alt="image" src="https://github.com/user-attachments/assets/3ad4ca1a-7bcb-423c-a910-90053f53ed5c" />
<br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="640" height="541" alt="image" src="https://github.com/user-attachments/assets/7d2d1f2d-fde8-480c-9329-a0775499859f" /><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="838" height="762" alt="image" src="https://github.com/user-attachments/assets/05a48951-6bf8-4767-aa72-d7b260d4c74c" /><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="838" height="762" alt="image" src="https://github.com/user-attachments/assets/7d8b9834-cacb-4568-adfb-2a0cb3081a92" />
<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;点击Next进入到模板选择，这里选择defineView。<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="838" height="762" alt="image" src="https://github.com/user-attachments/assets/3c6c3287-070d-4790-9e21-267d72af741e" />
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;这算是完成了第一个CDS View的建立。
</details>

## 🔶SQL <br>
<details><summary>简单的SQL说明</summary>
其实就是SQL文，常用的一定要知道！<br>
  <br>
内连接INNER JOIN<br>
 └─ 两个表的数据都要。<br>
<br>
左外连接LEFT OUTER JOIN<br>
 └─左边主表一定显示，右边有就带出来，没有就空。<br>

<br>
右外连接RIGHT OUTER JOIN<br>
 └─右边表一定显示，左边有就带出来。使用频率低。<br>
<br>
内连接影响主体，外连接影响附加信息<br>

</details>



## 🔶CDS View的代码分享<br>
🟣代表简单难度&nbsp;🌟代表高难度&nbsp;🔥代表重要<br>


🟣[单表](<./单表CDS View (old).js>)<br>
🟣[INNER JOIN](<./INNER JOIN.js>)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;缺点是 JOIN 写死了，复用性不如 Association。<br>
🌟[Association 写法](<./Association.js>)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;理解起来有些复杂，短时间不能理解，请立刻使用JOIN。<br>
🟣[WHERE 条件](<./WHERE条件.js>)<br>
🟣[带参数的 CDS View](<./带有参数取数据.md>)<br>
🟣[Case写法](<./CASE.js>)<br>
🔥[带有金额和数量](<./金额＆数量.md>)<br>
