# What is this thing?
It was my start at making a modern, gloriously layer-based Mac UI framework. Something similar to UIKit on iOS.

## 'Was'?
Twitter announced last week that they're going to open source TwUI, their modern, gloriously layer-based Mac UI framework which drives Twitter for Mac. This is fantastic news and I'm 100% sure it will kick MAUIKit's ass.

If TwUI is open to contributions when it's out, I look forward to contributing to its awesomeness.

## Is it full-featured?
Nope. Nowhere near. This was basically me testing out some ideas.

## So why bother open sourcing it?
Hopefully it will be helpful for someone. I learned a ton in the short time I worked on it.

# Subpixel Anti-Aliasing
So here's the thing. Text looks like shit without subpixel anti-aliasing. Unfortunately, text drawn into a layer-backed or layer-hosting view usually loses its subpixel anti-aliasing (for a lot of good and complicated reasons). One of my primary goals in creating MAUIKit was to find a way around this.

And I kinda did. It's not beautiful but it works. The quick answer is that MAUIView has a `flattenSubviews` property. By turning this property on, the MAUIView will composite all its subviews down into itself. This allows any MAUILabels in the view to be rendered with subpixel anti-aliasing.

I haven't extensively tested this. The quick sample app in the project is all there is. But it looks like the theory works. No doubt there are a bazillion edge cases that I haven't solved. It probably doesn't respect subview/sublayer ordering or z position.