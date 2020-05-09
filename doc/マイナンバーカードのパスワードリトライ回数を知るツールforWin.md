# はじめに
特別低額給付金。10万円の給付金の申請しましたか？

マイナンバーカードだとネットから簡単に申請できます。

ただし、申請には**「利用者証明用パスワード（4桁の数字）」**と**「署名用パスワード（半角6文字-16文字）」**の入力が必要です。



このパスワード。マイナンバーカードを受け取ったときに**自分で設定しているはず**です。にもかかわらず**「なにそのパスワード？」**という方（私）、気を付けましょう。このパスワードはクレジットカードのパスワードと同じで**何回か入力間違いするとカードにロックがかかってしまいます。**

ロックがかかると、そのマイナンバーカードは使えなくなってしまいます。
もちろんリセットして復旧させることができますが、**役所へGO**です。



> 署名用電子証明書については５回連続で、利用者証明用電子証明書については３回連続でパスワードを間違って入力した場合、パスワードロックがかかってしまい、当該電子証明書は利用できなくなってしまいます。
> 発行を受けた市区町村窓口にてパスワードのロック解除とともに、パスワード初期化申請をし、パスワードの再設定を行ってください。
> （注）パスワードのロック解除をする場合は、顔写真付き公的証明書による本人確認が必要となります。詳しくは市区町村窓口にお問い合わせください。

[パスワードの失念](https://www.jpki.go.jp/procedure/password.html)



役所では今（2020/5/9)パスワード再設定に**8時間超の待ち時間**だそうです。

[マイナンバー暗証番号再設定で自治体窓口が混雑　給付金オンライン申請巡り](https://mainichi.jp/articles/20200508/k00/00m/040/261000c)



[マイナポータル](https://myna.go.jp/)にはマイナンバーカードでログインできるのですが、このとき**「利用者証明用パスワード（4桁の数字）」**を入力します。



<img src=".\img\01.PNG" alt="01" style="zoom:67%;" />

<img src="C:\Users\suzuki\Documents\GitHub\JPKIPINTool\doc\img\02.PNG" alt="02" style="zoom:50%;" />



このとき、手続きのめんどくささをわかっていないのか、それとも、何が問題なのかをメッセージしないことがセキュアであるという仕様によるものなのか、**パスワード間違えた時のメッセージが不親切**なので、ついつい何度も入力してしまいます。

<img src=".\img\03.PNG" alt="03" style="zoom:50%;" />



と、いうわけで、**せめてパスワードのリトライ回数があと何回なのかわかりたい**、というところだけでもFIXできるように簡単なツールを作りました。



# 注意

- 自分の環境、自分のマイナンバーカードでしかテストしていません。
- 他の環境、マイナンバーカードではうまく動かないかもしれません。
- お遊びレベルのツールです。本ライブラリ・デモプログラムを利用することによって生じるいかなる問題についても、その責任を負いません。



# 環境

- Windows10 1903
- .Net Framework 4.6
- [パソリ-PaSoRi RC-S380](https://www.sony.co.jp/Products/felica/consumer/products/RC-S380.html)
- マイナンバーカード



# どんなもの？

早速つかってみます。

#### 1)ファイルをダウンロードします。

https://github.com/gebogebogebo/JPKIPINTool/tree/master/bin



#### 2)ファイルを同じフォルダに置きます。

- JPKIPINTool.bat

- JPKIPINTool.ps1

- JPKIReader.dll

- NLog.dll

  

#### 3)ICカード)リーダーをPCに接続してマイナンバーカードを乗せます。



#### 4)JPKIPINTool.batを実行します。

こんな感じで結果が出ればOK

```bat:
カードリーダーにマイナンバーカードが乗っているかどうかチェックします
- マイナンバーカード認識OK!
---
利用者証明用パスワード（4桁の数字）　いわゆる　認証 PINのリトライ回数をチェックします
- PINリトライ回数 = 3回
---
署名用パスワード（半角6文字-16文字）　いわゆる　署名 PINのリトライ回数をチェックします
- PINリトライ回数 = 5回
---

4 秒待っています。続行するには何かキーを押してください ...
```



こんだけです。



# 解説

昔作った**JPKIReader.dll**を使っています。JPKIReader.dllについては以下を参照ください。

- [マイナンバーカード検証#3 - 署名用電子証明書&Library JPKI Reader](https://qiita.com/gebo/items/37fcb50565c5ebeacb7b)
- [GitHub - JPKIReader](https://github.com/gebogebogebo/JPKIReader)



あとはpowershellとbatです。



JPKIPINTool.bat

```bat:JPKIPINTool.bat
powershell -NoProfile -ExecutionPolicy Unrestricted .\%~n0.ps1
Timeout 5
```



JPKIPINTool.bat

```powershell
Set-Location (Split-Path ( & { $myInvocation.ScriptName } ) -parent)
Add-Type -Path ".\JPKIReader.dll";

Write-Host "カードリーダーにマイナンバーカードが乗っているかどうかチェックします"

$result = [JPKIReaderLib.JPKIReader]::IsJPKICardExist()
if( $result -eq $false ) 
    Write-Host "- マイナンバーカードが認識できませんでした"
    return
}
Write-Host "- マイナンバーカード認識OK!"
Write-Host "---"


Write-Host "利用者証明用パスワード（4桁の数字）　いわゆる　認証 PINのリトライ回数をチェックします"
$result = [JPKIReaderLib.JPKIReader]::GetAuthenticationPINRetryCount()
$message = "- PINリトライ回数 = " + $result + "回"
Write-Host $message
Write-Host "---"

Write-Host "署名用パスワード（半角6文字-16文字）　いわゆる　署名 PINのリトライ回数をチェックします"
$result = [JPKIReaderLib.JPKIReader]::GetSignaturePINRetryCount()
$message = "- PINリトライ回数 = " + $result + "回"
Write-Host $message
Write-Host "---"
```



以下のAPIを使っています。引数もないんで簡単です。

- カードのチェック
  - IsJPKICardExist()
- 認証 PINのリトライ回数チェック
  - GetAuthenticationPINRetryCount()
- 署名 PINのリトライ回数チェック
  - GetSignaturePINRetryCount()



# もうちょっと解説

もうちょっとだけ解説します。

マイナンバーカードとお話するのは**APDU(Application Protocol Data Unit)**っていうコマンドを使うのですが、どんなAPDUをつかっているのか、だけ解説します。



## IsJPKICardExist()

マイナンバーカードには**公的個人認証AP**というアプリが入っているんで、このAPがあるかどうかでマイナンバーカードかどうかをチェックしています。



SELECT FILE 公的個人認証AP

```
0x00, 0xA4, 0x04, 0x0C, 0x0A, 0xD3, 0x92, 0xF0, 0x00, 0x26, 0x01, 0x00, 0x00, 0x00, 0x01
```



## GetAuthenticationPINRetryCount()

3発のコマンドです。

- 公的個人認証APに接続
- 認証用PINに接続
- PINリトライ回数をGET



```
//公的個人認証APに接続
0x00, 0xA4, 0x04, 0x0C, 0x0A, 0xD3, 0x92, 0xF0, 0x00, 0x26, 0x01, 0x00, 0x00, 0x00, 0x01

//認証用PINに接続
0x00, 0xA4, 0x02, 0x0C, 0x02, 0x00, 0x18

//PINリトライ回数をGET
0x00, 0x20, 0x00, 0x80

// Response = 0x63, 0xC3の場合
// 0x63 = リトライ回数がGETできたという意味
// リトライ回数は 0xC3 & 0x0F = 0x03 = 3回となります
```



## GetSignaturePINRetryCount()

3発のコマンドです。

- 公的個人認証APに接続
- 署名用PINに接続
- PINリトライ回数をGET



```
// 公的個人認証APに接続
0x00, 0xA4, 0x04, 0x0C, 0x0A, 0xD3, 0x92, 0xF0, 0x00, 0x26, 0x01, 0x00, 0x00, 0x00, 0x01

// 署名用PINに接続
0x00, 0xA4, 0x02, 0x0C, 0x02, 0x00, 0x1B

// PINリトライ回数をGET
0x00, 0x20, 0x00, 0x80

// Response = 0x63, 0xC5の場合
// 0x63 = リトライ回数がGETできたという意味
// リトライ回数は 0xC5 & 0x0F = 0x05 = 5回となります
```



これよりも詳細は以下の記事を見ていただければと思います。

- [マイナンバーカード検証#1 - まえおき](https://qiita.com/gebo/items/6a334b5453817a587683)
- [マイナンバーカード検証#2 - 利用者証明用電子証明書](https://qiita.com/gebo/items/fa35c1f725f4c443f3f3)
- [マイナンバーカード検証#3 - 署名用電子証明書&Library JPKI Reader](https://qiita.com/gebo/items/37fcb50565c5ebeacb7b)



# おつかれさまでした

これがjsとかスマホアプリでできればいいんだけど、そっち系はわからないんだよなぁ

