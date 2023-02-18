import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/models/produto.dart';
import 'package:stock/screens/produtos_admin.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:stock/services/produto_service.dart';
import 'package:stock/widgets/header.dart';

class DadosProdutosScreen extends StatefulWidget {
  const DadosProdutosScreen({
    Key? key,
    required this.produto,
  }) : super(key: key);

  final ProdutoModel produto;

  @override
  State<DadosProdutosScreen> createState() => _DadosProdutosScreenState();
}

class _DadosProdutosScreenState extends State<DadosProdutosScreen> {
  List<DepartamentoModel> departamentos = [];
  String userId = '';
  String userAvatar = '';
  String validacao = '';

  @override
  void initState() {
    getUser();
    getDepartamentos();
    super.initState();
  }

  Future getDepartamentos() async {
    departamentos = await DepartamentoService.getDepartamentos();
    setState(() {});
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id')!;
    userAvatar = prefs.getString('avatar')!;
  }

  Future getImage() async {
    XFile? imagem = await ImagePicker().pickImage(source: ImageSource.gallery);
    String base64Image = await _getBase64Image(imagem!);
    setState(() {
      widget.produto.imagem = 'data:image/png;base64,$base64Image';
    });
  }

  Future<String> _getBase64Image(XFile image) async {
    List<int> imageBytes = await image.readAsBytes();
    return base64Encode(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderWidget.buildAppBar(context, 'Produto', userAvatar),
        body: Container(
          alignment: Alignment.center,
          child: buildSizedBox(context, widget.produto),
        ),
        drawer: HeaderWidget.buildDrawer(context, userId, departamentos));
  }

  SizedBox buildSizedBox(context, produto) {
    TextEditingController nomeController =
        TextEditingController(text: produto.nome);
    TextEditingController departamentoController =
        TextEditingController(text: produto.departamento);
    TextEditingController estoqueController = TextEditingController(
        text: produto.estoque != null ? produto.estoque.toString() : '');
    TextEditingController descricaoController =
        TextEditingController(text: produto.descricao);
    TextEditingController precoController = TextEditingController(
        text: produto.preco != null ? produto.preco.toString() : '');
    return SizedBox(
      width: MediaQuery.of(context).size.height,
      child: Container(
        height: 600,
        width: 800,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: lightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            height: 200,
            width: 400,
            child: produto.imagem == null
                ? Container(
                    height: 100,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text('Nenhuma imagem selecionada',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)))
                : Image.network(produto.imagem),
          ),
          const SizedBox(height: 5),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(fontSize: 15),
            ),
            onPressed: () async {
              await getImage();
            },
            child: const Text('Selecione uma imagem'),
          ),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                child: TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Nome',
                      labelText: 'Nome',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: SizedBox(
                child: TextField(
                  controller: departamentoController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Departamento',
                      labelText: 'Departamento',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: SizedBox(
                child: TextField(
                  controller: estoqueController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Estoque',
                      labelText: 'Estoque',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
                child: SizedBox(
              child: TextField(
                controller: precoController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Preço',
                    labelText: 'Preço',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ))
          ]),
          const SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              child: TextField(
                controller: descricaoController,
                minLines: 6,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Descricao',
                    labelText: 'Descricao',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(validacao,
              style: const TextStyle(
                color: red,
              )),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              if (nomeController.text != '' &&
                  departamentoController.text != '' &&
                  estoqueController.text != '' &&
                  descricaoController.text != '' &&
                  precoController.text != '' &&
                  widget.produto.imagem != null) {
                produto.nome = nomeController.text;
                produto.departamento = departamentoController.text;
                produto.estoque = int.parse(estoqueController.text);
                produto.descricao = descricaoController.text;
                produto.preco = int.parse(precoController.text);
                ProdutoModel produtoResposta =
                    await ProdutoService.postProduto(produto);
                if (produtoResposta.id != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProdutosAdminScreen()));
                } else {
                  setState(() {
                    validacao =
                        'Erro ao cadastrar produto. Tente novamente mais tarde';
                  });
                }
              } else {
                setState(() {
                  validacao = 'Preencha todos os campos';
                });
              }
            },
            child: const Text('Salvar'),
          ),
        ]),
      ),
    );
  }
}
