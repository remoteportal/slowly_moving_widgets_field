# slowing_moving_widgets_field

**under construction**

Pass in a list of widgets and the slowing_moving_widgets_field moves them around the screen like an asteroids game, bouncing off each other.
 

# TODO
- parameterize background


# Bugs
- will fail (undefined results) if you try to add too many widgets; there must be adequate room to add all widgets initially so they are not overlapping.  
- sometimes the movers overlap and get suck on top of each other--not sure why.


# Usage
Add a new dependency line to your project/pubspec.yaml file:

```yaml
dependencies:
  ...
  slowing_moving_widgets_field: 0.1.0      # use latest version!
```

Don't forget to *flutter pub get*.


# Pull Requests
Pull requests are welcome!
