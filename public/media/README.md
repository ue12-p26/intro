# images

## layout

- astro imposes - I think - the favicon to sit under `/public`
- but the logo has to be in `/src`

## base URL

- also to avoid having to worry about the base URL, we refrain from using markdown images with `![]()`
- because it would require to hardwire the base URL in the markdown files
- hence the use of the `ImageLoader` component instead that will fetch the image from the right place

## tooling

- we do most of our figures under excalidraw
- however for the favicon it's best to use Inkscape as it allows to control the bounding box  
- (otherwise when exporting from excalidraw the bounding box is too large)
