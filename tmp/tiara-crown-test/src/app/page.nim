import crown/core
import tiara

proc page*(req: Request): string =
  return html"""
    <div class="p-10 text-center space-y-4 max-w-2xl mx-auto">
      <h1 class="text-4xl font-bold text-gray-800">Welcome to Crown 👑</h1>
      <p class="text-gray-600">
        Crown の App Router と <span class="font-semibold text-indigo-600">Tiara</span> の <code class="text-sm bg-slate-100 px-1 rounded">html</code> DSL で組み立てたデフォルトページです。
      </p>
      <p class="text-sm text-gray-400">編集: <code>src/app/page.nim</code> · 起動: <code>crown dev</code></p>
    </div>
  """
