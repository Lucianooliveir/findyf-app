import 'package:cached_network_image/cached_network_image.dart';
import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/models/animal_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimalProfilePage extends StatelessWidget {
  const AnimalProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AnimalModel animal = Get.arguments["animal"];
    return Scaffold(
      appBar: AppBar(
        title: Text(animal.nome),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animal Image
            Container(
              width: double.infinity,
              height: 350,
              child: CachedNetworkImage(
                imageUrl: "${Variables.baseUrl}/${animal.imagem}",
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.pets, size: 80, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(animal.nome,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(_getSpeciesIcon(animal.especie),
                          size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text("${animal.especie} • ${animal.raca}",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700])),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow("Porte", animal.porte, Icons.straighten),
                  const SizedBox(height: 8),
                  _buildInfoRow("Nascimento",
                      _formatDate(animal.data_nascimento), Icons.cake),
                  const SizedBox(height: 8),
                  _buildInfoRow("Idade", _calculateAge(animal.data_nascimento),
                      Icons.access_time),
                  if (animal.abrigo_infos != null) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const Text("Abrigo Responsável",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildShelterInfo(animal),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showContactDialog(context, animal),
                      icon: const Icon(Icons.favorite, color: Colors.white),
                      label: const Text(
                        "Tenho Interesse",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 18),
        const SizedBox(width: 8),
        Text("$label: ",
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500)),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildShelterInfo(AnimalModel animal) {
    final abrigo = animal.abrigo_infos!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.home, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(abrigo.nome_responsavel,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text("Verificado",
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow("CRMV", abrigo.crmv_responsavel, Icons.badge),
          const SizedBox(height: 4),
          _buildInfoRow("Telefone", abrigo.telefone, Icons.phone),
        ],
      ),
    );
  }

  IconData _getSpeciesIcon(String especie) {
    switch (especie.toLowerCase()) {
      case 'cão':
      case 'cachorro':
      case 'dog':
        return Icons.pets;
      case 'gato':
      case 'cat':
        return Icons.pets;
      case 'coelho':
      case 'rabbit':
        return Icons.cruelty_free;
      default:
        return Icons.pets;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _calculateAge(String dateString) {
    try {
      final birthDate = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(birthDate);
      final years = difference.inDays ~/ 365;
      final months = (difference.inDays % 365) ~/ 30;
      if (years > 0) {
        if (months > 0) {
          return "$years ano${years > 1 ? 's' : ''} e $months mês${months > 1 ? 'es' : ''}";
        } else {
          return "$years ano${years > 1 ? 's' : ''}";
        }
      } else if (months > 0) {
        return "$months mês${months > 1 ? 'es' : ''}";
      } else {
        final days = difference.inDays;
        return "$days dia${days > 1 ? 's' : ''}";
      }
    } catch (e) {
      return "Idade não disponível";
    }
  }

  void _showContactDialog(BuildContext context, AnimalModel animal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red),
              const SizedBox(width: 8),
              Text("Interesse em ${animal.nome}"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Que ótimo que você tem interesse em adotar! Entre em contato com o abrigo responsável:"),
              const SizedBox(height: 16),
              if (animal.abrigo_infos != null) ...[
                Text("📞 ${animal.abrigo_infos!.telefone}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Responsável: ${animal.abrigo_infos!.nome_responsavel}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Fechar"),
            ),
            ElevatedButton(
              onPressed: () async {
                String telefone = animal.abrigo_infos!.telefone;
                await launchUrl(Uri.parse("tel:$telefone"));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
              child:
                  const Text("Contatar", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
