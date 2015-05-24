Csvex
=====

Note, you have to give uniform list of maps (structs). Example of usage :

```
res = Csvex.encode([%{key1: 123, key2: 321}, %{key1: "qwe\n\r,", key2: "qwd,,"}])
File.write!("./foo.csv", res)
```

or

```
res = Csvex.encode([%{key1: 123, key2: 321}, %{key1: "qwe\n\r,", key2: "qwd,,"}], %{separator: ";", str_separator: "\r\n"})
File.write!("./foo.csv", res)
```

or

```
res = Csvex.encode([%{key1: 123, key2: 321}, %{key1: "qwe\n\r,", key2: "qwd,,"}], %{separator: ";", str_separator: "\r\n", keys: [:key2, :key1]})
File.write!("./foo.csv", res)
```

Next you can convert your file to *.xls file this way

```
csv2xls ./foo.csv
```