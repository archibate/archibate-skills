# RTK：一款精心设计的"浪费 Token"神器

> Rust Token Killer —— 名字起得真准，确实是在杀 Token，只不过是**往死里杀**。

## 设计哲学：为了省 Token，先把你的数据杀掉

RTK 的核心创新：暴力劫持 Agent 命令执行，当调用 `curl` 时，把 JSON 里的真实数据全部替换成类型标注！

```json
// 原始 API 返回
{"id": 1, "name": "张三", "email": "test@example.com"}

// RTK "优化"后
{id: int, name: string, email: string}
```

**省 Token 了！** 没错，只看这单一一次的指标，确实省了。但你拿到的是什么？一堆废话！

当你调试 API 的时候，你想知道的是 "张三"，不是 "string"！你想知道用户 ID 是 `1`，不是 `int`！

这就像你去餐厅点菜，服务员给你一张纸写着 "食物1 食物2"，然后说 "省墨水了"。

## 连管道都要劫持：给 jq 喂屎

最绝的是，RTK 连你 pipe 到 jq 的输出都要劫持：

```bash
rtk curl -s https://api.example.com | jq '.name'
# jq 报错：这不是合法的 JSON！
```

**牛啊！** 你把 JSON 变成了 YAML 风格的类型注解，然后喂给 jq 解析。这就好比把 PDF 打印出来，拍照，然后用 OCR 读回去，最后发现全是乱码。

## Agent：我 TM 怎么知道要 bypass？

RTK 插件安装后，强制劫持所有的 `curl` 命令！Agent 以为自己在执行 `curl`，实际上被自动改成了 `rtk curl`！

RTK 提供了 `rtk proxy` 作为绕过方式。但问题来了：

**Claude、GPT、Copilot：我哪知道要写 `rtk proxy`？**

在自动安装的提示词中根本就只是淡淡的提了一嘴！

```bash
rtk proxy <cmd>       # Execute raw command without filtering (for debugging)
```

没有任何 When-Then 的明确指示，根本联想不到自己的 curl 命令已经被"默认配置"掉包！

Agent 看到的就只是 "curl 返回了奇怪的 schema"，然后开始怀疑人生：
- 是 API 坏了？
- 是我的命令写错了？
- 还是这个世界疯了？

于是 Agent 开始反复重试、查文档、换命令……**Token 爆炸！**

你原本想省 100 个 Token，结果 Agent 调试了 10 轮，花了 2000 个 Token。

**RTK：我帮你省 Token！**
**我：你帮我破产！**

## 类型推断还是靠猜？

更搞笑的是，我们实测发现，RTK 的类型推断是靠猜的：

```json
{"zipcode": "92998-3874"}
// RTK 输出：
zipcode: date?
```

**邮编是 date？** 你见过哪个邮编是日期格式的？这种 "智能" 类型推断，不如叫 "随机乱猜"。

## 总结

RTK 解决了一个问题：你的 Token 太多了，想浪费一些。

它通过以下方式实现：
1. 把有用的数据变成没用的类型标注
2. 破坏所有依赖 JSON 格式的工具链
3. 让 Agent 陷入无尽的调试循环
4. 最终消耗比你不用 RTK 多 10 倍的 Token

**Rust Token Killer，名副其实 —— 杀的是你的 Token，废的是你的钱。**

---

*P.S. 作者可能想说 "节省 Token 送到 LLM"，但实际效果是 "Kill 你的 Token 预算"。建议改名：RTW (Rust Token Waster)。*
