yajsw-stable-11.07

    Bug: checking java 7
    Bug: Memory Leak -> update to netty 3.5.6
    Bug: wrapped applications started concurrently may have the same out_, err_, in_ file names.
    Bug: Linux: Permission denied since 11.4
    Change: forward wrapper java options used in the configuration to the wrapped application
    New: new property: wrapper.ntservice.reduce_signals
    New: new property: wrapper.console.use_interpolated
    New: new property: wrapper.app.status.log.lines