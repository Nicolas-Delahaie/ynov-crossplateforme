/// Types de profils dans le jeu.
///
/// - [linkedin] : Profil professionnel LinkedIn
/// - [interpol] : Criminel recherché par Interpol
enum ProfileType { linkedin, interpol }

/// Modèle représentant un profil à deviner.
///
/// Chaque profil contient une photo et des informations contextuelles
/// pour aider (ou tromper) le joueur.
class Profile {
  /// Identifiant unique du profil
  final String id;

  /// URL de la photo de profil
  final String imageUrl;

  /// Type de profil (LinkedIn ou Interpol)
  final ProfileType type;

  /// Information contextuelle (poste, entreprise, ou charges criminelles)
  final String? context;

  Profile({
    required this.id,
    required this.imageUrl,
    required this.type,
    this.context,
  });

  /// Crée un [Profile] depuis un objet JSON.
  ///
  /// Format attendu :
  /// ```json
  /// {
  ///   "id": "001",
  ///   "imageUrl": "https://example.com/image.jpg",
  ///   "type": "linkedin",
  ///   "context": "Software Engineer"
  /// }
  /// ```
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      type: json['type'] == 'linkedin' 
          ? ProfileType.linkedin 
          : ProfileType.interpol,
      context: json['context'] as String?,
    );
  }

  /// Convertit le profil en objet JSON pour sérialisation.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'type': type == ProfileType.linkedin ? 'linkedin' : 'interpol',
      'context': context,
    };
  }
}
