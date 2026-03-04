import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<Movie> _allMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    //data sudah siap, delay menampilkan tampilan
    final List<Map<String, dynamic>> allMoviesData = await _apiService
        .getAllMovies();
    final List<Map<String, dynamic>> trendingMoviesData = await _apiService
        .getTrendingMovies();
    final List<Map<String, dynamic>> popularMoviesData = await _apiService
        .getPopularMovies();

    setState(() {
      //diupdate statenya, kalau ada data baru, bisa langsung ditambhkan
      _allMovies = allMoviesData.map((e) => Movie.fromJson(e)).toList();
      _trendingMovies = trendingMoviesData
          .map((e) => Movie.fromJson(e))
          .toList();
      _popularMovies = popularMoviesData.map((e) => Movie.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      //scaffold terdiri dari appbar dan body
      appBar: AppBar(title: const Text('Pilem')),
      body: SingleChildScrollView(
        //membungkus semua widget
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieList(
              'All Movies',
              _allMovies,
            ), //data list == kartu2 horizontal yg bergilir
            _buildMovieList('Trending Movies', _trendingMovies),
            _buildMovieList('Popular Movies', _popularMovies),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          //bungkus dengan padding, kolomnya
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          //kasih gap antar kotak
          height:
              200, //List View dibungkus dgn Sized Box dengan dikasih gap brp height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies
                .length, //menampilkan bnyk item yg ditampilin di List View
            itemBuilder: (context, index) {
              final Movie movie = movies[index];
              return Column(
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                    height: 150,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    movie.title.length > 14
                        ? '${movie.title.substring(0, 10)}...'
                        : movie.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
