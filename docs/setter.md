# Setter

## args_set_description

Set a usage description.
Concat all arguments.

### example

```bash
args_set_description "your description " "message"
```

## args_set_epilog

Set a epilog description.
Concat all arguments.

### example

```bash
args_set_epilog "your epilog " "message"
```

## args_set_alternative

Set alternative mode for getopt.

### example

```bash
args_set_alternative "true"
```

## args_set_usage_width

Set the widths of usage message

|Parameter|Description|
|---|---|
|$1|padding|
|$2|argument|
|$3|separator|
|$4|help|

```bash
args_set_usage_width 2 20 2 56
```

Set the usage witdhs.

<img src="images/headerUsageWidth.drawio.png" />

```bash
args_set_usage_width 2 20 2 56
```

<img src="images/example1UsageWidth.drawio.png" />

```bash
args_set_usage_width 2 30 2 15
```

<img src="images/example2UsageWidth.drawio.png" />

```bash
args_set_usage_width 1 21 1 30
```

<img src="images/example3UsageWidth.drawio.png" />