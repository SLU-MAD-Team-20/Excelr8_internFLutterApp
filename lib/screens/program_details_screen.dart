import 'package:flutter/material.dart';
import '../models/program_model.dart';
import '../services/program_service.dart';

class ProgramDetailsScreen extends StatefulWidget {
  final String? programId;
  final ProgramModel? program;

  const ProgramDetailsScreen({
    super.key,
    this.programId,
    this.program,
  });

  @override
  State<ProgramDetailsScreen> createState() => _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends State<ProgramDetailsScreen> {
  late final ProgramService _programService;
  ProgramModel? _program;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _programService = ProgramService();
    _loadProgram();
  }

  Future<void> _loadProgram() async {
    try {
      if (widget.program != null) {
        setState(() {
          _program = widget.program;
          _isLoading = false;
        });
        return;
      }

      if (widget.programId == null || widget.programId!.isEmpty) {
        final programs = await _programService.getPrograms();
        if (programs.isNotEmpty) {
          setState(() {
            _program = programs.first;
            _isLoading = false;
          });
          return;
        }
        throw Exception('No programs available');
      }

      final loadedProgram = await _programService.getProgramById(widget.programId!);
      setState(() {
        _program = loadedProgram;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Details'),
        backgroundColor: Colors.blue,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    if (_program == null) {
      return const Center(child: Text('No program found.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school,
              size: 100,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _program!.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Duration: ${_program!.duration ?? 'Not available'}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            'Start Date: ${_program!.startDate ?? 'Not available'}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            'Status: ${_program!.status}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            'Registered: ${_program!.registeredCount}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _program!.description ?? 'No description available.',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Enroll Now'),
            ),
          ),
        ],
      ),
    );
  }
}