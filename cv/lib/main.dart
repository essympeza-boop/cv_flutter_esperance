import 'package:cv/AddFamille.dart';
import 'package:cv/ApiExeption.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EsperanceApp());
}

const violet = Color(0xFF7041A6);
const rose = Color(0xFFE7A4C7);
const fondSombre = Color.fromARGB(255, 41, 32, 37);

const degrade = LinearGradient(
  colors: [violet, rose],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class EsperanceApp extends StatelessWidget {
  const EsperanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV Esperance Ishimwe',
      theme: ThemeData(
        scaffoldBackgroundColor: fondSombre,
        colorScheme: ColorScheme.fromSeed(seedColor: violet),
        useMaterial3: true,
        // Barre du haut violette pour toutes les pages
        appBarTheme: const AppBarTheme(
          backgroundColor: violet,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        // Champs de saisie blancs, lisibles sur le fond sombre
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      home: const ConnexionPage(),
    );
  }
}

// ---------- Fonctions utiles ----------

void afficherMessage(BuildContext context, String texte) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texte)));
}

void deconnexion(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const ConnexionPage()),
    (route) => false,
  );
}

// ---------- Page 1 : connexion ----------

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _mdp = TextEditingController();
  bool _masque = true;
  bool _chargement = false;

  @override
  void dispose() {
    _email.dispose();
    _mdp.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _chargement = true;
    });
    try {
      await ApiService.login(_email.text.trim(), _mdp.text);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AccueilPage()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      afficherMessage(context, e.message);
    } finally {
      if (mounted) {
        setState(() {
          _chargement = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: degrade),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_pin,
                      size: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'BIENVENUE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'CV Esperance Mpeza Ishimwe',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Identifiant (e-mail)',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Saisissez votre identifiant'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mdp,
                      obscureText: _masque,
                      onFieldSubmitted: (_) => _seConnecter(),
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _masque ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _masque = !_masque;
                            });
                          },
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Saisissez votre mot de passe'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: violet,
                        ),
                        onPressed: _chargement ? null : _seConnecter,
                        child: _chargement
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: violet,
                                ),
                              )
                            : const Text(
                                'Se connecter',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InscriptionPage(),
                          ),
                        );
                      },
                      child: const Text('Créer un compte'),
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

// ---------- Création de compte ----------

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _mdp = TextEditingController();
  final _confirmation = TextEditingController();
  bool _chargement = false;

  @override
  void dispose() {
    _email.dispose();
    _mdp.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _creer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _chargement = true;
    });
    try {
      await ApiService.register(_email.text.trim(), _mdp.text);
      if (!mounted) return;
      afficherMessage(context, 'Compte créé, connectez-vous');
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      afficherMessage(context, e.message);
    } finally {
      if (mounted) {
        setState(() {
          _chargement = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: degrade),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (v) => (v == null || !v.contains('@'))
                        ? 'E-mail invalide'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mdp,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (v) => (v == null || v.length < 4)
                        ? '4 caractères minimum'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmation,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (v) =>
                        v != _mdp.text ? 'Les mots de passe diffèrent' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: violet,
                      ),
                      onPressed: _chargement ? null : _creer,
                      child: _chargement
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: violet,
                              ),
                            )
                          : const Text(
                              'Créer le compte',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
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
}

// ---------- Navigation (barre du bas) ----------

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  int page = 0;

  // Chargé une seule fois, partagé par l'accueil et le contact
  final Future<Etudiant?> _etudiant = ApiService.etudiant();

  @override
  Widget build(BuildContext context) {
    final pages = [
      CvPage(etudiant: _etudiant),
      const FamillePage(),
      ContactPage(etudiant: _etudiant),
    ];

    return Scaffold(
      body: IndexedStack(index: page, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (index) {
          setState(() {
            page = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: 'Mon CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

// ---------- Page 2 : CV ----------

class CvPage extends StatelessWidget {
  final Future<Etudiant?> etudiant;
  const CvPage({super.key, required this.etudiant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Curriculum Vitae',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout),
            onPressed: () => deconnexion(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: degrade,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/image.jfif',
                    width: 125,
                    height: 125,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 125,
                        height: 125,
                        color: Colors.white,
                        child: const Icon(
                          Icons.person,
                          size: 75,
                          color: violet,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                // Le nom vient de l'API (valeur de secours si indisponible)
                FutureBuilder<Etudiant?>(
                  future: etudiant,
                  builder: (context, snap) {
                    return Text(
                      snap.data?.nomComplet ?? 'esperance mpeza ishimwe',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  'Étudiante à l’ISIG',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          sectionTitre('A PROPOS DE MOI'),
          info('Date de naissance', '07 septembre 2005'),
          sectionTitre('MON PARCOURS'),
          info('École primaire', 'EP : BAHANUZI'),
          info('École secondaire', 'LYCEE CHEMCHEM'),
          info('Université', 'ISIG'),
          sectionTitre('COMPÉTENCES'),
          const Text(
            ',......... a SUIVRE',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          sectionTitre('LANGUES'),
          const Text(
            'Les langues parlées seront dispo.',
            style: TextStyle(fontSize: 15, color: Colors.white70),
          ),
          sectionTitre('CENTRES D’INTÉRÊT'),
          const Text(
            'A compléter.',
            style: TextStyle(fontSize: 15, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '© esperance mpeza Ishimwe',
              style: TextStyle(color: rose, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Page 3 : famille (ajouter, modifier, supprimer) ----------

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  late Future<List<FamilleMembre>> _futur = ApiService.famille();

  Future<void> _recharger() async {
    setState(() {
      _futur = ApiService.famille();
    });
    await _futur.catchError((_) => <FamilleMembre>[]);
  }

  // Ajout (membre == null) ou modification
  Future<void> _ouvrirFormulaire({FamilleMembre? membre}) async {
    final change = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddFamilyPage(membre: membre)),
    );
    if (change == true) {
      if (!mounted) return;
      afficherMessage(
        context,
        membre == null ? 'Membre ajouté' : 'Membre modifié',
      );
      _recharger();
    }
  }

  Future<void> _supprimer(FamilleMembre m) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text('Voulez-vous vraiment supprimer ${m.nomComplet} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme != true) return;

    try {
      await ApiService.supprimerMembre(m.id);
      if (!mounted) return;
      afficherMessage(context, 'Membre supprimé');
      _recharger();
    } on ApiException catch (e) {
      if (!mounted) return;
      afficherMessage(context, e.message);
    }
  }

  Widget _entete() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 166, 65, 127), rose],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(Icons.family_restroom, color: Colors.white, size: 65),
          SizedBox(height: 10),
          Text(
            'MA FAMILLE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _carte(FamilleMembre m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _ouvrirFormulaire(membre: m), // appui = modifier
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 12, 4, 12),
            child: Row(
              children: [
                avatarMembre(m),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.nomComplet,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(m.parente, style: const TextStyle(color: violet)),
                      Text(
                        'Né(e) le ${m.dateNaissance} à ${m.lieuNaissance}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (choix) {
                    if (choix == 'modifier') _ouvrirFormulaire(membre: m);
                    if (choix == 'supprimer') _supprimer(m);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'modifier',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Modifier'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'supprimer',
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Supprimer'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ma famille')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _ouvrirFormulaire(),
        backgroundColor: violet,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text('Ajouter'),
      ),
      body: FutureBuilder<List<FamilleMembre>>(
        future: _futur,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(color: rose));
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${snap.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _recharger,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }
          final membres = snap.data!;
          return RefreshIndicator(
            onRefresh: _recharger,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
              children: [
                _entete(),
                const SizedBox(height: 20),
                if (membres.isEmpty)
                  const Center(
                    child: Text(
                      'Aucun membre. Appuyez sur « Ajouter ».',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                for (final m in membres) _carte(m),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Photo ronde : fichier de l'application (assets/...), adresse web, ou icône
Widget avatarMembre(FamilleMembre m) {
  final img = (m.image ?? '').trim();
  const icone = Center(child: Icon(Icons.person, size: 30, color: violet));

  Widget photo;
  if (img.startsWith('assets/')) {
    photo = Image.asset(
      img,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => icone,
    );
  } else if (m.imageUrl != null) {
    photo = Image.network(
      m.imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => icone,
    );
  } else {
    photo = icone;
  }

  return ClipOval(
    child: Container(
      width: 56,
      height: 56,
      color: rose.withOpacity(0.4),
      child: photo,
    ),
  );
}

// ---------- Page 4 : contact ----------

class ContactPage extends StatelessWidget {
  final Future<Etudiant?> etudiant;
  const ContactPage({super.key, required this.etudiant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Me contacter')),
      body: FutureBuilder<Etudiant?>(
        future: etudiant,
        builder: (context, snap) {
          final e = snap.data;
          final nom = e?.nomComplet ?? 'esperance mpeza ishimwe';
          final tel = (e != null && e.telephone.isNotEmpty)
              ? e.telephone
              : '+243 976162070';
          final adresse = (e != null && e.adresse.isNotEmpty)
              ? e.adresse
              : 'GOMA';

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: rose,
                  child: Icon(Icons.person, size: 65, color: violet),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                nom,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              info('Téléphone', tel),
              info('Adresse', adresse),
              info('Facebook', 'ESPERANCE MPEZA'),
              info('TikTok', 'ES MPEZA'),
              info('Lieu de naissance', 'GOMA'),
            ],
          );
        },
      ),
    );
  }
}

// ---------- Éléments d'affichage communs ----------

Widget sectionTitre(String titre) {
  return Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 10),
    child: Text(
      titre,
      style: const TextStyle(
        color: rose,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget info(String titre, String valeur) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titre,
          style: const TextStyle(color: violet, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          valeur,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
    ),
  );
}
