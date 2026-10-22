import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class SummaryScreen extends StatefulWidget {
  final UserProfile profil;
  const SummaryScreen({super.key, required this.profil});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _formKey = GlobalKey<FormState>();

  void _confirmer() {
    if (!_formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Compte créé !'),
        content: Text('Bienvenue ${widget.profil.prenom}, votre inscription est validée.'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.popUntil(context, (r) => r.isFirst);
            },
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
  }

  Widget _carte(String titre, List<(IconData, String, String)> lignes) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(titre, style: Theme.of(context).textTheme.titleLarge),
            ),
            for (final l in lignes)
              ListTile(
                leading: Icon(l.$1),
                title: Text(l.$2),
                subtitle: Text(l.$3.isEmpty ? '—' : l.$3),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.profil;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Récapitulatif de votre profil'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(value: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recommencer',
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _carte('Identité', [
                (Icons.person, 'Nom complet', p.nomComplet),
                (Icons.email, 'E-mail', p.email),
              ]),
              const SizedBox(height: 16),
              _carte('Profil professionnel', [
                (Icons.work, 'Profession', p.profession),
                (Icons.timeline, 'Expérience', '${p.experience} an(s)'),
                (Icons.euro, 'TJM', '${p.tjm} €'),
                (Icons.notes, 'Biographie', p.biographie),
              ]),
              const SizedBox(height: 16),
              FormField<bool>(
                initialValue: false,
                validator: (v) =>
                    v == true ? null : "Vous devez accepter les conditions d'utilisation",
                builder: (state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      value: state.value,
                      onChanged: state.didChange,
                      title: const Text("J'accepte les conditions"),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          state.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _confirmer,
                child: const Text('Confirmer et créer le compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}