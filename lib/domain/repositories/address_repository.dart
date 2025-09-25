import 'dart:convert';
import 'package:flutter/services.dart';

class Department {
  final int id;
  final String name;
  final List<String> cities;

  Department({
    required this.id,
    required this.name,
    required this.cities,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json['id'] ?? 0,
        name: json['departamento'] ?? '',
        cities: List<String>.from(json['ciudades']?.map((x) => x) ?? []),
      );
}

class AddressRepository {
  // Cargar departamentos desde el archivo JSON
  Future<List<Department>> loadColombianDepartments() async {
    try {
      final String response = await rootBundle.loadString('assets/jsons/colombia.json');
      final List<dynamic> data = await json.decode(response);
      return data.map((json) => Department.fromJson(json)).toList();
    } catch (e) {
      // En caso de error, devolver lista vacía
      return [];
    }
  }

  // Obtener las ciudades de un departamento por su nombre
  Future<List<String>> getCitiesByDepartment(String departmentName) async {
    final departments = await loadColombianDepartments();
    final department = departments.firstWhere(
      (dept) => dept.name.toLowerCase() == departmentName.toLowerCase(),
      orElse: () => Department(id: -1, name: '', cities: []),
    );
    return department.cities;
  }

  // Validar si una ciudad pertenece a un departamento
  Future<bool> validateCity(String departmentName, String cityName) async {
    final cities = await getCitiesByDepartment(departmentName);
    return cities.any((city) => city.toLowerCase() == cityName.toLowerCase());
  }
}
