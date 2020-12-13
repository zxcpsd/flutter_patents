import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

import '../models/inventor.dart';
import '../models/patent.dart';

class NetHelper {
  static const String urlBase = 'https://api.patentsview.org/patents/query';
  static const String responseFormat =
      '&f=["inventor_id","inventor_last_name","inventor_first_name","patent_number","patent_date","patent_title","patent_abstract"]';
  static String options(int page) => '&o={"page":$page,"per_page":50}';
  static int currentPage = 1;
  static int currentTotalCount = 0;
  static Future<PatentWithAuthors> getPatent(String pid) async {
    final String query = '$urlBase?q={"patent_number":"$pid"}$responseFormat';
    print('GET: $query');
    try {
      http.Response result = await http.get(query);
      if (result.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(result.body);
        if (jsonResponse['count'] == 0) {
          print('Nothing found.');
          return null;
        }
        currentPage = 1;
        currentTotalCount = 1;
        return _patentWAList(jsonResponse)[0];
      } else {
        return null;
      }
    } on Exception {
      print('No internet connection');
      return null;
    }
  }

  static List<PatentWithAuthors> _patentWAList(dynamic jsonResponse) {
    List<PatentWithAuthors> list =
        List.generate(jsonResponse['patents'].length, (index) {
      final patentJson = jsonResponse['patents'][index];
      Patent patent = Patent(
          0,
          patentJson["patent_number"],
          patentJson['patent_date'],
          patentJson['patent_title'],
          patentJson['patent_abstract']);
      List<Inventor> invList =
          List.generate(patentJson['inventors'].length, (i) {
        return Inventor.fromJson(patentJson['inventors'][i]);
      });
      print('Found patent: ${patent.title}');
      return PatentWithAuthors(patent, invList);
    }).toList();
    return list;
  }

  static Future<List<PatentWithAuthors>> getPatents(
      String firstName, String lastName, String dateFrom, String dateTo,
      [int page = 1]) async {
    List<String> list = [
      (dateFrom == null) ? '' : '{"_gte":{"patent_date":"$dateFrom"}}',
      (dateTo == null) ? '' : '{"_lte":{"patent_date":"$dateTo"}}',
      (firstName == null)
          ? ''
          : '{"_contains":{"inventor_first_name":"$firstName"}}',
      (lastName == null)
          ? ''
          : '{"_contains":{"inventor_last_name":"$lastName"}}'
    ];
    list.removeWhere((i) => (i == ''));
    final String query =
        '$urlBase?q={"_and":[${list.join(',')}]}$responseFormat${options(page)}';
    print('GET: $query');
    try {
      http.Response result = await http.get(query);
      if (result.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(result.body);
        if (jsonResponse['count'] == 0) {
          print('Nothing found.');
          return null;
        }
        currentPage = page;
        currentTotalCount = jsonResponse["total_patent_count"];
        return _patentWAList(jsonResponse);
      } else {
        return null;
      }
    } on Exception {
      print('No internet connection');
      return null;
    }
  }

  static Future<List<PatentWithAuthors>> getPatentsByStringQueryList(
      List<String> names,
      [int page = 1]) async {
    final String query =
        '$urlBase?q={"_text_any":{"patent_title":"${names.join(' ')}"}}$responseFormat${options(page)}';
    try {
      print('GET: $query');
      http.Response result = await http.get(query);
      if (result.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(result.body);
        if (jsonResponse['count'] == 0) {
          print('Nothing found.');
          return null;
        }
        currentPage = page;
        currentTotalCount = jsonResponse["total_patent_count"];
        return _patentWAList(jsonResponse);
      } else {
        return null;
      }
    } on Exception {
      print('No internet connection');
      return null;
    }
  }
}
