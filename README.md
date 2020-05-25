# 15-minute-city

A website to explore Liverpool where your everyday needs are within a 15 minute walk or cycle

## Intro

(This blurb lifted from [the somebody-should issue where initial investigations happened](https://github.com/Liverpool-UK/somebody-should/issues/35))

Via Dan Hill's excellent (if extensive :-) [Slowdown Papers](https://medium.com/slowdown-papers/11-post-traumatic-urbanism-and-radical-indigenism-c2a21dc7ba69) I learnt of Paris' plans for a "15 minute city":

> This simple notion — that all your basic everyday needs, from education to commerce to healthcare to culture and so on, are located within 15 minutes walk or bike of your front door

That seems to me like a good tool for thinking about how to make the city more walkable, and to explore how the city might adapt to include more local, distributed approaches (particularly post-pandemic and with an increasing climate crisis).

A few years back, the Liverpool Architectural Society ran the Integrated City Project, which had some echoes of this.  I'm not sure much of it ever ended up online, and now all I can find is [my blog post about it](http://www.mcqn.net/mcfilter/archives/liverpool/liverpool_architecture_societys_integrated_city_project.html).

However, it does give us this interesting map of 32 areas of the city, which we could take as a starting point to see how we fare at the moment.

![A map of Liverpool showing the 32 areas spread across it](http://www.mcqn.net/mcfilter/images/LiverpoolCityMap.jpg)

Lots of these areas have existing focal points for shops, libraries, etc.  Maybe we can identify gaps that we can work to fill, or barriers that make it hard for the flow of people between neighbouring areas.  Or maybe we'll realise we already have a 15-minute city, and we just need to think about it differently.

## Design Thoughts

Taking a lead from [this site showing accessibility of Amsterdam schools](https://github.com/waagsociety/scholen) we can maybe build a Jekyll site to generate a bunch of isochrones for the 32 city areas, and then have Leaflet.js/Turf.js load them and allow visitors to generate new ones for points of their choosing.

It would be good to build a land-use tile set too, to show residential/retail/office/industrial/amenity/green space, as that will let people see what is missing/over-supplied/etc. from each area.
