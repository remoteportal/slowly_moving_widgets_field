# slowing_moving_widgets_field

Pass in a list of arbitrary widgets and the slowing_moving_widgets_field widget moves them around the screen, like the old asteroids video game.

If collisionAmount is null then widgets float on top of each other (don't bounce).

If collisionAmount is non-null then widgets will bounce when they hit each other (collision detection).  But, this is buggy (see below).
 
Returns a Stack() object.  This is where the magic happens! (homage to "Wayne's World")


# Example
![Screenshot](example.gif)


# TODO
- specify background
- specify a slight amount of randomness on every impact
- specify how much overlap (positive or negative) to allow before bounce
- specify speed
- specify "soft bounce" mode that causes close widgets to repel off of each other rather than instantaneous bounce


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
  slowing_moving_widgets_field: 1.0.28      # use latest version!
```

Don't forget to *flutter pub get*


# Pull Requests
Pull requests are welcome!