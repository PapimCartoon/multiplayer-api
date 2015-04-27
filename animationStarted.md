
```
animationStarted()
```

### Description ###

Call this when you start an animation ,this function will make sure all new server input will be suspended in the container until the animation ends.
you can signal the end of an animation by using the [animationEnded](animationEnded.md) function.

note that you may call animationStarted several times, but you will have to call [animationEnded](animationEnded.md) once for each animationStarted call you make