// arka fona gradyan eklendi, butonlar değiştirildi (son hal)
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> _imageUrls = [];
  String _selectedLabel = '';
  int _currentIndex = 0;
  bool _completed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final ListResult result =
        await FirebaseStorage.instance.ref().child('images').listAll();

    final List<String> urls = await Future.wait(result.items.map((ref) {
      return ref.getDownloadURL();
    }));

    setState(() {
      _imageUrls = urls;
      _loading = false;
    });
  }

  Future<void> _uploadLabel(String label) async {
    final labelRef = await FirebaseFirestore.instance
        .collection('labels')
        .where('imageUrl', isEqualTo: _imageUrls[_currentIndex])
        .get();

    if (labelRef.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('labels').add({
        'label': label,
        'imageUrl': _imageUrls[_currentIndex],
        'timestamp': Timestamp.now(),
      });
    } else {
      final docId = labelRef.docs.first.id;
      await FirebaseFirestore.instance.collection('labels').doc(docId).update({
        'label': label,
        'timestamp': Timestamp.now(),
      });
    }

    if (_currentIndex < _imageUrls.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedLabel = '';
      });
    } else {
      setState(() {
        _completed = true;
      });
    }
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    } else if (_completed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your work is completed.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _restartProcess,
              child: Text('Relabel images'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.network(
                  _imageUrls[_currentIndex],
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  _selectedLabel.isEmpty ? 'Label:' : _selectedLabel,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_currentIndex > 0) {
                          setState(() {
                            _currentIndex--;
                            _selectedLabel = '';
                          });
                        }
                      },
                      child: const Text('Previous Image'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label A');
                        setState(() {
                          _selectedLabel = 'Label A selected';
                        });
                      },
                      child: const Text('Label A'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label B');
                        setState(() {
                          _selectedLabel = 'Label B selected';
                        });
                      },
                      child: const Text('Label B'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label C');
                        setState(() {
                          _selectedLabel = 'Label C selected';
                        });
                      },
                      child: const Text('Label C'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]);
    }
  }

  void _restartProcess() {
    setState(() {
      _completed = false;
      _currentIndex = 0;
      _selectedLabel = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 198, 223, 247),
              Color.fromARGB(255, 246, 248, 246)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildBody(),
      ),
    );
  }
} 








/* // resim hizalanması denemesi1 -istediğim gibi olmadı-
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> _imageUrls = [];
  String _selectedLabel = '';
  int _currentIndex = 0;
  bool _completed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final ListResult result =
        await FirebaseStorage.instance.ref().child('images').listAll();

    final List<String> urls = await Future.wait(result.items.map((ref) {
      return ref.getDownloadURL();
    }));

    setState(() {
      _imageUrls = urls;
      _loading = false;
    });
  }

  Future<void> _uploadLabel(String label) async {
    final labelRef = await FirebaseFirestore.instance
        .collection('labels')
        .where('imageUrl', isEqualTo: _imageUrls[_currentIndex])
        .get();

    if (labelRef.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('labels').add({
        'label': label,
        'imageUrl': _imageUrls[_currentIndex],
        'timestamp': Timestamp.now(),
      });
    } else {
      final docId = labelRef.docs.first.id;
      await FirebaseFirestore.instance.collection('labels').doc(docId).update({
        'label': label,
        'timestamp': Timestamp.now(),
      });
    }

    if (_currentIndex < _imageUrls.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedLabel = '';
      });
    } else {
      setState(() {
        _completed = true;
      });
    }
  }

 Widget _buildBody() {
  if (_loading) {
    return Center(child: CircularProgressIndicator());
  } else if (_completed) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your work is completed.',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _restartProcess,
            child: Text('Relabel images'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
            ),
          ),
        ],
      ),
    );
  } else {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ClipRect(
                    child: Image.network(
                      _imageUrls[_currentIndex],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  _selectedLabel.isEmpty ? 'Label:' : _selectedLabel,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _currentIndex > 0
                          ? () {
                              setState(() {
                                _currentIndex--;
                                _selectedLabel = '';
                              });
                            }
                          : null,
                      child: const Text('Previous Image'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label A');
                        setState(() {
                          _selectedLabel = 'Label A selected';
                        });
                      },
                      child: const Text('Label A'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label B');
                        setState(() {
                          _selectedLabel = 'Label B selected';
                        });
                      },
                      child: const Text('Label B'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label C');
                        setState(() {
                          _selectedLabel = 'Label C selected';
                        });
                      },
                      child: const Text('Label C'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


  void _restartProcess() {
    setState(() {
      _completed = false;
      _currentIndex = 0;
      _selectedLabel = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 198, 223, 247), Color.fromARGB(255, 246, 248, 246)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildBody(),
      ),
    );
  }
} */




/* import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> _imageUrls = [];
  String _selectedLabel = '';
  int _currentIndex = 0;
  bool _completed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final ListResult result =
        await FirebaseStorage.instance.ref().child('images').listAll();

    final List<String> urls = await Future.wait(result.items.map((ref) {
      return ref.getDownloadURL();
    }));

    setState(() {
      _imageUrls = urls;
      _loading = false;
    });
  }

  Future<void> _uploadLabel(String label) async {
    final labelRef = await FirebaseFirestore.instance
        .collection('labels')
        .where('imageUrl', isEqualTo: _imageUrls[_currentIndex])
        .get();

    if (labelRef.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('labels').add({
        'label': label,
        'imageUrl': _imageUrls[_currentIndex],
        'timestamp': Timestamp.now(),
      });
    } else {
      final docId = labelRef.docs.first.id;
      await FirebaseFirestore.instance.collection('labels').doc(docId).update({
        'label': label,
        'timestamp': Timestamp.now(),
      });
    }

    if (_currentIndex < _imageUrls.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedLabel = '';
      });
    } else {
      setState(() {
        _completed = true;
      });
    }
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    } else if (_completed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your work is completed.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _restartProcess,
              child: Text('Relabel images'),
            ),
          ],
        ),
      );
    } else {
      return Column(children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.network(
                  _imageUrls[_currentIndex],
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _selectedLabel,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_currentIndex > 0) {
                          setState(() {
                            _currentIndex--;
                            _selectedLabel = '';
                          });
                        }
                      },
                      child: const Text('Previous Image'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label A');
                        setState(() {
                          _selectedLabel = 'Label A selected';
                        });
                      },
                      child: const Text('Label A'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label B');
                        setState(() {
                          _selectedLabel = 'Label B selected';
                        });
                      },
                      child: const Text('Label B'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label C');
                        setState(() {
                          _selectedLabel = 'Label C selected';
                        });
                      },
                      child: const Text('Label C'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]);
    }
  }

  void _restartProcess() {
    setState(() {
      _completed = false;
      _currentIndex = 0;
      _selectedLabel = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }
}
 */


/* //relabel images butonu eklendi + label butonları yukarı kaldırıldı+ sondaki yazılar ortalandı
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> _imageUrls = [];
  String _selectedLabel = '';
  int _currentIndex = 0;
  bool _completed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final ListResult result =
        await FirebaseStorage.instance.ref().child('images').listAll();

    final List<String> urls = await Future.wait(result.items.map((ref) {
      return ref.getDownloadURL();
    }));

    setState(() {
      _imageUrls = urls;
      _loading = false;
    });
  }

  Future<void> _uploadLabel(String label) async {
    final labelRef = await FirebaseFirestore.instance
        .collection('labels')
        .where('imageUrl', isEqualTo: _imageUrls[_currentIndex])
        .get();

    if (labelRef.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('labels').add({
        'label': label,
        'imageUrl': _imageUrls[_currentIndex],
        'timestamp': Timestamp.now(),
      });
    } else {
      final docId = labelRef.docs.first.id;
      await FirebaseFirestore.instance.collection('labels').doc(docId).update({
        'label': label,
        'timestamp': Timestamp.now(),
      });
    }

    if (_currentIndex < _imageUrls.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedLabel = '';
      });
    } else {
      setState(() {
        _completed = true;
      });
    }
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    } else if (_completed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your work is completed.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _restartProcess,
              child: Text('Relabel images'),
            ),
          ],
        ),
      );
    } else {
      return Column(children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.network(
                  _imageUrls[_currentIndex],
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _selectedLabel,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_currentIndex > 0) {
                          setState(() {
                            _currentIndex--;
                            _selectedLabel = '';
                          });
                        }
                      },
                      child: const Text('Previous Image'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label A');
                        setState(() {
                          _selectedLabel = 'Label A selected';
                        });
                      },
                      child: const Text('Label A'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label B');
                        setState(() {
                          _selectedLabel = 'Label B selected';
                        });
                      },
                      child: const Text('Label B'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label C');
                        setState(() {
                          _selectedLabel = 'Label C selected';
                        });
                      },
                      child: const Text('Label C'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]);
    }
  }

  void _restartProcess() {
    setState(() {
      _completed = false;
      _currentIndex = 0;
      _selectedLabel = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }
} */


/* //final test page (yeniden etiketleme yapılabiliyor, sorunsuz)
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> _imageUrls = [];
  String _selectedLabel = '';
  int _currentIndex = 0;
  bool _completed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final ListResult result =
        await FirebaseStorage.instance.ref().child('images').listAll();

    final List<String> urls = await Future.wait(result.items.map((ref) {
      return ref.getDownloadURL();
    }));

    setState(() {
      _imageUrls = urls;
      _loading = false;
    });
  }

  Future<void> _uploadLabel(String label) async {
    final labelRef = await FirebaseFirestore.instance
        .collection('labels')
        .where('imageUrl', isEqualTo: _imageUrls[_currentIndex])
        .get();

    if (labelRef.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('labels').add({
        'label': label,
        'imageUrl': _imageUrls[_currentIndex],
        'timestamp': Timestamp.now(),
      });
    } else {
      final docId = labelRef.docs.first.id;
      await FirebaseFirestore.instance.collection('labels').doc(docId).update({
        'label': label,
        'timestamp': Timestamp.now(),
      });
    }

    if (_currentIndex < _imageUrls.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedLabel = '';
      });
    } else {
      setState(() {
        _completed = true;
      });
    }
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    } else if (_completed) {
      return Center(
        child: Text(
          'Your work is completed.',
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.network(
                    _imageUrls[_currentIndex],
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _selectedLabel,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_currentIndex > 0) {
                          setState(() {
                            _currentIndex--;
                            _selectedLabel = '';
                          });
                        }
                      },
                      child: const Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label A');
                        setState(() {
                          _selectedLabel = 'Label A selected';
                        });
                      },
                      child: const Text('Label A'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label B');
                        setState(() {
                          _selectedLabel = 'Label B selected';
                        });
                      },
                      child: const Text('Label B'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label C');
                        setState(() {
                          _selectedLabel = 'Label C selected';
                        });
                      },
                      child: const Text('Label C'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }
} */


/* //geri butonlu - 3 labellı
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> _imageUrls = [];
  String _selectedLabel = '';
  int _currentIndex = 0;
  bool _completed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final ListResult result =
        await FirebaseStorage.instance.ref().child('images').listAll();

    final List<String> urls = await Future.wait(result.items.map((ref) {
      return ref.getDownloadURL();
    }));

    setState(() {
      _imageUrls = urls;
      _loading = false;
    });
  }

  Future<void> _uploadLabel(String label) async {
    await FirebaseFirestore.instance.collection('labels').add({
      'label': label,
      'timestamp': Timestamp.now(),
    });

    if (_currentIndex < _imageUrls.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedLabel = '';
      });
    } else {
      setState(() {
        _completed = true;
      });
    }
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    } else if (_completed) {
      return Center(
        child: Text(
          'Your work is completed.',
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.network(
                    _imageUrls[_currentIndex],
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _selectedLabel,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _currentIndex == 0
                          ? null
                          : () {
                              setState(() {
                                _currentIndex--;
                                _selectedLabel = '';
                              });
                            },
                      child: const Text('Geri'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label A');
                        setState(() {
                          _selectedLabel = 'Label A selected';
                        });
                      },
                      child: const Text('Label A'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label B');
                        setState(() {
                          _selectedLabel = 'Label B selected';
                        });
                      },
                      child: const Text('Label B'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label C');
                        setState(() {
                          _selectedLabel = 'Label C selected';
                        });
                      },
                      child: const Text('Label C'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: _buildBody(),
    );
  }
} */


/* //geri butonsuz
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> _imageUrls = [];
  String _selectedLabel = '';
  int _currentIndex = 0;
  bool _completed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final ListResult result =
        await FirebaseStorage.instance.ref().child('images').listAll();

    final List<String> urls = await Future.wait(result.items.map((ref) {
      return ref.getDownloadURL();
    }));

    setState(() {
      _imageUrls = urls;
      _loading = false;
    });
  }

  Future<void> _uploadLabel(String label) async {
    await FirebaseFirestore.instance.collection('labels').add({
      'label': label,
      'timestamp': Timestamp.now(),
    });

    if (_currentIndex < _imageUrls.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedLabel = '';
      });
    } else {
      setState(() {
        _completed = true;
      });
    }
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    } else if (_completed) {
      return Center(
        child: Text(
          'Your work is completed.',
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.network(
                    _imageUrls[_currentIndex],
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _selectedLabel,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label A');
                        setState(() {
                          _selectedLabel = 'Label A selected';
                        });
                      },
                      child: const Text('Label A'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label B');
                        setState(() {
                          _selectedLabel = 'Label B selected';
                        });
                      },
                      child: const Text('Label B'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadLabel('Label C');
                        setState(() {
                          _selectedLabel = 'Label C selected';
                        });
                      },
                      child: const Text('Label C'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: _buildBody(),
    );
  }
} */
