# GenArtCanvas

Collaborative generative art canvas app built with Flutter & Firebase. It was built for a talk titled "[Real-time Animated Generative Art with Flutter & Firebase](https://f3.events/speakers/2f098344-5408-4cb7-8a70-ac2f0058d21f/)" given at the [Flutter Firebase Festival 2023](https://f3.events/)

## Inside The App
Initially, the app loads with animated cuboids shapes in grayscale colors

https://github.com/Roaa94/gen_art_canvas/assets/50345358/2efd0834-a5fa-4da7-9d85-3af28608a5f5

After enough entries through a simple UI in the app that allows you to add your own cuboids to the canvas, the canvas can look like this:
(these are the cuboids entered by the audience in the the Flutter Firebase Festival talk)


https://github.com/Roaa94/gen_art_canvas/assets/50345358/9f850879-05ba-4d59-9467-845e352a81ff

And here's what the UI to create cuboids looks like:

https://github.com/Roaa94/gen_art_canvas/assets/50345358/36805800-a3cd-45e4-8382-0e2d4e22b711

🔗 [Through this demo link, you can view the canvas if you are on a devide with a big screen, or you can view the the cuboid creation UI if you visit on a small screen](https://genart-canvas.roaakdm.com/)

## App Architecture & Folder Structure
With **Flutter** for the painting (of course!), **Riverpod** for dependency injection & state management, and **Firebase** for backend, the app architecture & folder structure is heavily inspired by [Andrea Bizzotto](https://twitter.com/biz84)'s [Starter Architecture With Flutter and Firebase repository](https://github.com/bizz84/starter_architecture_flutter_firebase) (📃 You can check out Andrea's [articles](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/) to read more about Flutter app architecture with Riverpod)

<img width="1356" alt="image" src="https://github.com/Roaa94/gen_art_canvas/assets/50345358/2f9bd547-b897-4686-93f4-0d44e666b0f8">


### Firebase Anonymous Authentication
Using Firebase authentication, you can easily sign users in anonymously by calling:
```dart
FirebaseAuth.instance.signInAnonymously();
```
In the app, when a user first opens the [link](https://genart-canvas.roaakdm.com/) (on a small device), they are presented with a simple dialog:

<img width="254" alt="image" src="https://github.com/Roaa94/gen_art_canvas/assets/50345358/ebdacfa9-2a9a-4bf1-afc8-21ad56e6b4ff">

Behind the scenes, tapping on Start, is anonymously signing the user in with Firebase anonymous authentication.
This is the quickest way to allow users to access the app without going through a tedious sign up process, while at the same time allowing them to work with your database protected by security rules.
Later on, you can give users the option to sign up, and link their permanent account with their anonymous sign in and keep whatever data you stored for them.

#### Code peak
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

### Firebase Firestore Database
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

#### Code peak

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




