# GenArtCanvas

Collaborative generative art canvas app built with Flutter & Firebase. It was built for a talk titled "[Real-time Animated Generative Art with Flutter & Firebase](https://f3.events/speakers/2f098344-5408-4cb7-8a70-ac2f0058d21f/)" given at the [Flutter Firebase Festival 2023](https://f3.events/)

## Inside The App
Initially, the app loads to an empty canvas of  animated cuboid shapes in grayscale colors

https://github.com/Roaa94/gen_art_canvas/assets/50345358/2efd0834-a5fa-4da7-9d85-3af28608a5f5

After enough entries through a simple UI in the app that allows you to add your own cuboids to the canvas, the canvas can look like this:
(these are the cuboids entered by the audience in the the Flutter Firebase Festival talk)

https://github.com/Roaa94/gen_art_canvas/assets/50345358/9f850879-05ba-4d59-9467-845e352a81ff

And here's what the UI to create cuboids looks like:

https://github.com/Roaa94/gen_art_canvas/assets/50345358/36805800-a3cd-45e4-8382-0e2d4e22b711

🔗 [Through this demo link, you can view the canvas if you are on a devide with a big screen, or you can view the the cuboid creation UI if you visit on a small screen](https://genart-canvas.roaakdm.com/)

## App Architecture & Folder Structure
With **Flutter** for the painting (of course!), **Riverpod** for dependency injection & state management, and **Firebase** for the backend, the app architecture & folder structure is heavily inspired by [Andrea Bizzotto](https://twitter.com/biz84)'s [Starter Architecture With Flutter and Firebase repository](https://github.com/bizz84/starter_architecture_flutter_firebase) (📃 You can check out Andrea's [articles](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/) to read more about Flutter app architecture with Riverpod)

<img width="1356" alt="image" src="https://github.com/Roaa94/gen_art_canvas/assets/50345358/2f9bd547-b897-4686-93f4-0d44e666b0f8">

## Painting the Canvas with Flutter's CustomPainter

For each cuboid shape, each face is painted as a regular rectangle using `Rect.fromLTWH()`, and then using canvas transformations, the face is transformed into its desired shape to achieve the isometric (3D-ish) look depending on its direction. 
* The top face is scaled on the Y axis by **0.5** and rotated **45 degrees** to achieve the isometric look.
* The left face is skewed by **0.5** on the Y axis and scaled down on the X axis to match the top face and achieve the isometric look.
* The right face is skewed by **-0.5** on the Y axis and scaled down on the X axis to match the top face and achieve the isometric look.
* Additional translations are performed to make sure all cuboids faces are perfectly aligned.
* `canvas.save()` and `canvas.restore()` methods are used to save the canvas transformation before performing it so the canvas can be restored before the transformations of the next cuboid face.
* For each face, before the canvas is restored, additional painting can be done based on the cuboid data coming from the database, and this is how the configurations selected by the users (a.k.a artists) in the form gets painted into the final canvas.

```dart
// Inside the `CustomPainter`'s `paint()` method
final topFacePath = Path()..addRect(Rect.fromLTWH(0, 0, side, side));

// Paint top face
canvas.save()
canvas.translate(diagonal / 2, 0)
canvas.scale(1, yScale)
canvas.rotate(45 * pi / 180)
canvas.drawPath(topFacePath, topFacePaint);
// ⚠️ User- (a.k.a Artists-) crafted paths for the top face
canvas.restore();

// Paint left face
final leftFacePath = Path()..addRect(Rect.fromLTWH(0, 0, side, size.height));

canvas.save()
canvas.translate(0, diagonal / 2 * yScale)
canvas.skew(0, yScale)
canvas.scale(skewedScaleX, 1)
canvas.drawPath(leftFacePath, leftFacePaint);
// ⚠️ User- (a.k.a Artists-) crafted paths for the left face
canvas.restore();

// Paint right face
final rightFacePath = Path()..addRect(Rect.fromLTWH(0, 0, side, size.height));

canvas.save()
canvas.translate(diagonal / 2, diagonal * yScale)
canvas.skew(0, -yScale)
canvas.scale(skewedScaleX, 1)
canvas.drawPath(rightFacePath, rightFacePaint);
// ⚠️ User- (a.k.a Artists-) crafted paths for the right face
canvas.restore();
```

## Animating the Canvas

* To achieve the animation, first a list of random offsets is generated, these are the offsets the cuboids are going to animate to on each iteration. And these offsets are re-generated for each iteration of the animation to achieve more randomization.
* To actually run an animation, an `AnimationController` is created and `animationController.repeat(reverse: true)` is called on it in the `initState` method of the widget. 
* This animation controller is then passed to the `CustomPainter`'s `repaint` parameter, which basically makes it keep repainting as the animation controller is running.
* The provided animation controller is used to create a custom `Animation` object with the desired `Curve` and this animation object is used with Flutter's built-in `Offset.lerp` method to create an animation between the cuboid's initial offset and its randomized offset.

```dart
class CuboidsCanvasPainter extends CustomPainter {
  CuboidsCanvasPainter({
    required this.randomYOffsets,
    required AnimationController animationController,
    //...
  })  : animation = CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        super(repaint: animationController);

  late final Animation<double> animation;
  final List<double> randomYOffsets;
  //...

  @override
  void paint(Canvas canvas, Size size) {
    //...
    for (var index = 0; index < settings.cuboidsTotalCount; index++) {
      final j = index ~/ cuboidsCrossAxisCount;
      final i = index % cuboidsCrossAxisCount;

      final cuboidData = cuboids.length - 1 >= index ? cuboids[index] : null;
      final xOffset = _someMath(index);
      final yOffset = _moreMath(index);
      final beginOffset = Offset(xOffset, yOffset);
      final endOffset = Offset(beginOffset.dx, beginOffset.dy + randomYOffsets[index]);
      // ⚠️ Using the animation
      final animatedYOffset = Offset.lerp(beginOffset, endOffset, animation.value) ?? beginOffset;

      // Painting the cuboid
    }
  }

  //...
}
```

## Firebase Anonymous Authentication
Using Firebase authentication, you can easily sign users in anonymously by calling:
```dart
FirebaseAuth.instance.signInAnonymously();
```
In the app, when a user first opens the [link](https://genart-canvas.roaakdm.com/) (on a small device), they are presented with a simple dialog:

<img width="254" alt="image" src="https://github.com/Roaa94/gen_art_canvas/assets/50345358/ebdacfa9-2a9a-4bf1-afc8-21ad56e6b4ff">

Behind the scenes, tapping on Start, is anonymously signing the user in with Firebase anonymous authentication.
This is the quickest way to allow users to access the app without going through a tedious sign up process, while at the same time allowing them to work with your database protected by security rules.
Later on, you can give users the option to sign up, and link their permanent account with their anonymous sign in and keep whatever data you stored for them.

### Code peak
As seen from the architecture above, the outside world is accessed by the app's code through repositories. For authentication, the `AuthRepository` implements the anonymous sign in method:

```dart
class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Future<User?> signInAnonymously() async {
    final credentials = await _auth.signInAnonymously();
    return credentials.user;
  }

  //...
}
```

A Riverpod provider is used to inject the `FirebaseAuth.instance` and allow global access to this repository.

```dart
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(FirebaseAuth.instance),
);
```

## Firebase Firestore Database
The functionality of the app with realtime update of the canvas by audience creation was made possible with the Firestore database. To do this, 3 collections were implemented in the database: `canvas_settings`, `cuboids`, and `artists`.

* The cuboids canvas settings document holds the predefined number of cuboids initially laid out, as well as the supported colors and fill types that you choose from when you craft your cuboid.
```
/canvas_settings/cuboids_canvas_settings
                  ├── cuboidsTotalCount
                  ├── colors
                  ├── fillTypes
                  .
                  .
```

* The cuboid documents hold the necessary information for the app to know what to paint for each face

```
/cuboids/[cuboidId]
          ├── artistId
          ├── createdAt
          ├── topFace
          │   ├── fillType
          │   ├── fillColor
          │   ├── strokeColor
          │   ├── strokeWidth
          │   └── intensity
          ├── rightFace
          │   ├── fillType
          .   .
```

* Artists collection compliments anonymous users and holds data relevant to their creations

```
/artists/[artistId]
          ├── createdCuboidsCount
          ├── joinedAt
          └── nickname
```

### Code peak

The following query is performed to subscribe to changes on the `cuboids` collection. It filters cuboids created after a predefined date, orders them by their `createdAt` timestamp, and limits the number of cuboids by the predefined number in the settings document.

```dart
FirebaseFirestore.instance.collection('cuboids')
    .where(
      'createdAt',
      isGreaterThan: Timestamp.fromDate(
        DateTime.now().subtract(const Duration(hours: 1)),
      ),
    )
    .orderBy('createdAt', descending: true)
    .limit(settingsCuboidsTotalCount)
    .snapshots()
```

Inside the app, this is done through the `CuboidsRepository`:

```dart
class CuboidsRepository implements FirestoreRepository<Cuboid> {
  CuboidsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  String get collectionName => 'cuboids';

  //...

  Stream<List<Cuboid>> watchCuboids({int limit = 1}) {
    return collection
        .where(
          'createdAt',
          isGreaterThan: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 1)),
          ),
        )
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()).toList());
  }
}
```

Which is then accessed with a Riverpod provider that injects it with the `FirebaseFirestore.instance`

```dart
final cuboidsRepositoryProvider = Provider<CuboidsRepository>(
  (ref) => CuboidsRepository(FirebaseFirestore.instance),
);
```

## Start Creating! 🎨
Why not try it out yourself by visiting [this link](https://genart-canvas.roaakdm.com/)?
Remember that you need to be on a device with a large screen to be able to see the canvas.



