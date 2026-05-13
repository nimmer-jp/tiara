## Crown のレイアウトフック。当サイトの各ページはフル HTML を返し `disableLayout` するため、
## ここは恒等に近いフォールバックのみ。
proc layout*(html: string): string =
  html
