import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

enum ShapeImage { oval, react }

class ImageLoad extends StatefulWidget {
  final String? image;
  final ImageProvider? placeholder;
  final Color? placeholderColor;
  final ShapeImage shapeImage;
  final BoxFit fit;
  final Widget? errorWidget;
  final double? radius;
  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomLeftRadius;
  final double? bottomRightRadius;
  final double? height;
  final double? width;

  ImageLoad({
    Key? key,
    this.image,
    this.placeholder,
    this.placeholderColor,
    this.shapeImage = ShapeImage.react,
    this.fit = BoxFit.fill,
    this.errorWidget,
    this.radius,
    this.topLeftRadius,
    this.topRightRadius,
    this.bottomLeftRadius,
    this.bottomRightRadius,
    this.height,
    this.width,
  })  : assert(
            (radius != null &&
                    (topLeftRadius == null &&
                        topRightRadius == null &&
                        bottomLeftRadius == null &&
                        bottomRightRadius == null)) ||
                (radius == null &&
                    (topLeftRadius != null ||
                        topRightRadius != null ||
                        bottomLeftRadius != null ||
                        bottomRightRadius != null)) ||
                (radius == null &&
                    (topLeftRadius == null ||
                        topRightRadius == null ||
                        bottomLeftRadius == null ||
                        bottomRightRadius == null)),
            "Provide either all radius, or individual radius only"),
        super(key: key);

  @override
  _ImageLoadState createState() => _ImageLoadState();
}

class _ImageLoadState extends State<ImageLoad> {
  @override
  Widget build(BuildContext context) {
    // debugPrint("{Image: ${widget.image}");
    if (widget.image != null &&
        widget.image!.isNotEmpty &&
        widget.image != "null") {
      // debugPrint("NOT empty}");
      return getOvalOrReact(getImageNetwork());
    } else {
      // debugPrint("IS empty}");
      return getOvalOrReact(getPlaceholder());
    }
  }

  Widget getOvalOrReact(Widget child) {
    return Container(
        height: widget.height,
        width: widget.width,
        child: widget.shapeImage == ShapeImage.react
            ? ClipRRect(
                borderRadius: widget.radius != null
                    ? BorderRadius.circular(widget.radius ?? 10.0)
                    : BorderRadius.only(
                        topRight: Radius.circular(widget.topRightRadius ?? 0.0),
                        topLeft: Radius.circular(widget.topLeftRadius ?? 0.0),
                        bottomRight:
                            Radius.circular(widget.bottomRightRadius ?? 0.0),
                        bottomLeft:
                            Radius.circular(widget.bottomLeftRadius ?? 0.0),
                      ),
                child: child,
              )
            : ClipOval(child: child));
  }

  Widget getImageNetwork() {
    return FadeInImage(
      image: widget.image == null
          ? AppImages.userPlaceholder.image().image
          : NetworkImage(widget.image ?? ""),
      fit: widget.fit,
      placeholder:
          widget.placeholder ?? AppImages.userPlaceholder.image().image,
      imageErrorBuilder: (context, _, stackTrace) {
        return widget.errorWidget ?? getPlaceholder();
      },
    );
  }

  Image getPlaceholder() {
    return Image(
      image: widget.placeholder ?? AppImages.userPlaceholder.image().image,
      color:
          widget.placeholder == null ? AppColors.gray : widget.placeholderColor,
      fit: widget.fit,
    );
  }
}
