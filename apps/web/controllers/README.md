# 一般向けページのアクション

このフォルダ内には一般向けページの全てのアクションクラスのファイルがある

それぞれのアクションの詳細は個別のファイル先頭にコメントで記述してある

以下のアクションに共通するモジュールについては、`apps/web/application.rb`で指定されている

## ベースモジュール
全てのアクションに共通する処理をまとめたモジュールが`base.rb`である.
全てのアクションはこのファイルに記述されたメソッドを呼び出すことができる.

## 認証モジュール
全てのアクションに共通する、ログイン認証に関連する処理をまとめたモジュールが`authentication.rb`である

# ドキュメントへのリンク
[https://guides.hanamirb.org/actions/overview/](https://guides.hanamirb.org/actions/overview/)
