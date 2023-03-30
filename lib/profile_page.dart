// circle avatar halkalı, renkli yazılar, sign out (son hal)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'test_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  late User? _user;
  late String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user!.photoURL != null) {
      setState(() {
        _photoUrl = _user!.photoURL;
      });
    } else {
      _getGoogleProfileImage();
    }
  }

  Future<void> _getGoogleProfileImage() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signInSilently();
    if (googleUser != null) {
      setState(() {
        _photoUrl = googleUser.photoUrl;
      });
    }
  }

  void _saveProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;

      // Save the profile data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
        'experience': _experienceController.text,
        'position': _positionController.text,
      });

      // Navigate to the test screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TestPage()),
      );
    }
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        centerTitle: true,
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut();
            },
          ),
        ],

        // Remove old code
      ),
      body: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 198, 223, 247),
        Color.fromARGB(255, 246, 248, 246),
      ],
    ),
  ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  if (_photoUrl != null)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              Color.fromARGB(255, 59, 58, 58), // border color
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(_photoUrl!),
                          radius: 60.0,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.lightGreen,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Name:',
                              style: TextStyle(
                                fontSize: 16.0,
                                //backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name!';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.lightGreen,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Age:',
                              style: TextStyle(
                                fontSize: 16.0,
                                //backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your age!';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid age!';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.lightGreen,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Experience:',
                              style: TextStyle(
                                fontSize: 16.0,
                                //backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _experienceController,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your experience!';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.lightGreen,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Position:',
                              style: TextStyle(
                                fontSize: 16.0,
                                //backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _positionController,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your position!';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _saveProfile(context),
                      child: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}




/* // circle avatar halkalı, renkli yazılar, sign out (son hal)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'test_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  late User? _user;
  late String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user!.photoURL != null) {
      setState(() {
        _photoUrl = _user!.photoURL;
      });
    } else {
      _getGoogleProfileImage();
    }
  }

  Future<void> _getGoogleProfileImage() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signInSilently();
    if (googleUser != null) {
      setState(() {
        _photoUrl = googleUser.photoUrl;
      });
    }
  }

  void _saveProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;

      // Save the profile data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
        'experience': _experienceController.text,
        'position': _positionController.text,
      });

      // Navigate to the test screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TestPage()),
      );
    }
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        centerTitle: true,
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut();
            },
          ),
        ],

        // Remove old code
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  if (_photoUrl != null)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              Color.fromARGB(255, 59, 58, 58), // border color
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(_photoUrl!),
                          radius: 60.0,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.lightGreen,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Name',
                              style: TextStyle(
                                fontSize: 16.0,
                                //backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.lightGreen,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Age',
                              style: TextStyle(
                                fontSize: 16.0,
                                //backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your age';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.lightGreen,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Experience',
                              style: TextStyle(
                                fontSize: 16.0,
                                //backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _experienceController,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your experience';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.lightGreen,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Position',
                              style: TextStyle(
                                fontSize: 16.0,
                                //backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _positionController,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your position';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _saveProfile(context),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} */

/* // circle avatar eklendi, save butonu ortalandı (şimdilik son hali)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'test_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  late User? _user;
  late String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user!.photoURL != null) {
      setState(() {
        _photoUrl = _user!.photoURL;
      });
    } else {
      _getGoogleProfileImage();
    }
  }

  Future<void> _getGoogleProfileImage() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signInSilently();
    if (googleUser != null) {
      setState(() {
        _photoUrl = googleUser.photoUrl;
      });
    }
  }

  void _saveProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;

      // Save the profile data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
        'experience': _experienceController.text,
        'position': _positionController.text,
      });

      // Navigate to the test screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TestPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        centerTitle: true,
        leading: null, // Remove old code
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  if (_photoUrl != null)
                    Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_photoUrl!),
                        radius: 60.0,
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Name',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Age',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your age';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Experience',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        TextFormField(
                          controller: _experienceController,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your experience';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Position',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        TextFormField(
                          controller: _positionController,
                          decoration: const InputDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your position';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _saveProfile(context),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} */

/* //profile_page son hal
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'test_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  void _saveProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;

      // Save the profile data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
        'experience': _experienceController.text,
        'position': _positionController.text,
      });

      // Navigate to the test screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TestPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _experienceController,
                  decoration: const InputDecoration(
                    labelText: 'Experience',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your experience';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _positionController,
                  decoration: const InputDecoration(
                    labelText: 'Position',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your position';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveProfile(context),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} */

/* //1
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'test_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  void _saveProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;

      // Save the profile data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
        'experience': _experienceController.text,
        'position': _positionController.text,
      });

      // Navigate to the test screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TestPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _experienceController,
                  decoration: const InputDecoration(
                    labelText: 'Experience',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your experience';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _positionController,
                  decoration: const InputDecoration(
                    labelText: 'Position',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your position';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveProfile(context),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} */
