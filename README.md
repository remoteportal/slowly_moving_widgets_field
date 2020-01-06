# slowing_moving_widgets_field

Pass in a list of arbitrary widgets and the slowing_moving_widgets_field widget moves them around the screen, like the old asteroids video game

if collisionAmount is null then widgets float on top of each other (DON'T bounce)
if collisionAmount is non-null then widgets will bounce when they hit each other (collision detection).  But, this is buggy (see below)
 
Returns a Stack() which contains all the "magic"


# TODO
- parameterize background


# Bugs
- will fail (undefined results) if you try to add too many widgets; there must be adequate room to add all widgets initially so they are not overlapping  
- if collision detection is enabled (collisionAmount != null), sometimes the movers overlap and get stuck on top of each other--not sure why


# Design Flaws
- don't like having to specify width and height more than once (see example)


# Usage
Add a new dependency line to your project/pubspec.yaml file:

```yaml
dependencies:
  ...
  slowing_moving_widgets_field: 0.1.0      # use latest version!
```

Don't forget to *flutter pub get*


# Pull Requests
Pull requests are welcome!
