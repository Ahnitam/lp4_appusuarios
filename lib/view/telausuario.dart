import 'package:bd_usuarios/dados/banco.dart';
import 'package:bd_usuarios/model/usuario.dart';
import 'package:bd_usuarios/view/detalhe.dart';
import 'package:bd_usuarios/view/telamenu.dart';
import 'package:flutter/material.dart';

class TelaUsuario extends StatefulWidget {
  const TelaUsuario({Key? key}) : super(key: key);

  @override
  State<TelaUsuario> createState() => _TelaUsuarioState();
}

class _TelaUsuarioState extends State<TelaUsuario> {
  Banco bd = Banco();
  TextEditingController controllerAddCpfUsuario = TextEditingController();
  TextEditingController controllerAddNomeUsuario = TextEditingController();
  TextEditingController controllerAddEmailUsuario = TextEditingController();
  TextEditingController controllerAddLoginUsuario = TextEditingController();
  TextEditingController controllerAddSenhaUsuario = TextEditingController();
  TextEditingController controllerAddAvatarUsuario = TextEditingController();

  TextEditingController controllerEditarCpfUsuario = TextEditingController();
  TextEditingController controllerEditarNomeUsuario = TextEditingController();
  TextEditingController controllerEditarEmailUsuario = TextEditingController();
  TextEditingController controllerEditarLoginUsuario = TextEditingController();
  TextEditingController controllerEditarSenhaUsuario = TextEditingController();
  TextEditingController controllerEditarAvatarUsuario = TextEditingController();

  List<Usuario>? usuarios = [];

  Future<void> _listarUsuarios() async {
    usuarios = await bd.listarUsuarios();

    setState(() {
      usuarios;
    });
  }

  Future<void> _deletarUsuario(int i) async {
    await bd.deletarUsuario(i);

    setState(() {
      usuarios;
    });
  }

  _editarUsuario(int id, String cpf, String nome, String email, String login, String senha, String avatar) async{
    await bd.editarUsuario(
        Usuario(
          id: id,
          cpf: cpf,
          nome: nome,
          email: email,
          login: login,
          senha: senha,
          avatar: avatar,
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    _listarUsuarios();

    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: const Text("Lista de usuários"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: usuarios!.length,
                itemBuilder: (context, index){

                  if(usuarios!.isNotEmpty == true) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return TelaDetalhe(usuarios![index]);
                            })
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: usuarios![index].avatar == "" ? Icon(Icons.account_circle, color: Colors.blue,) : CircleAvatar(backgroundImage: NetworkImage(usuarios![index].avatar!),),
                          title: Text(usuarios![index].nome!),
                          subtitle: Text(usuarios![index].email!),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: (){

                                    controllerEditarCpfUsuario.text = usuarios![index].cpf!;
                                    controllerEditarNomeUsuario.text = usuarios![index].nome!;
                                    controllerEditarEmailUsuario.text = usuarios![index].email!;
                                    controllerEditarLoginUsuario.text = usuarios![index].login!;
                                    controllerEditarSenhaUsuario.text = usuarios![index].senha!;
                                    controllerEditarAvatarUsuario.text = usuarios![index].avatar!;

                                    showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            title: const Text("Editar Usuário"),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    keyboardType: TextInputType.number,
                                                    decoration: const InputDecoration(
                                                        labelText: "Cpf",
                                                        hintText: "digite seu cpf"
                                                    ),
                                                    controller: controllerEditarCpfUsuario,
                                                  ),
                                                  TextField(
                                                    keyboardType: TextInputType.text,
                                                    decoration: const InputDecoration(
                                                        labelText: "Nome",
                                                        hintText: "digite seu nome"
                                                    ),
                                                    controller: controllerEditarNomeUsuario,
                                                  ),
                                                  TextField(
                                                    keyboardType: TextInputType.emailAddress,
                                                    decoration: const InputDecoration(
                                                        labelText: "E-mail",
                                                        hintText: "digite seu e-mail"
                                                    ),
                                                    controller: controllerEditarEmailUsuario,
                                                  ),
                                                  TextField(
                                                    keyboardType: TextInputType.text,
                                                    decoration: const InputDecoration(
                                                        labelText: "Login",
                                                        hintText: "digite seu login"
                                                    ),
                                                    controller: controllerEditarLoginUsuario,
                                                  ),
                                                  TextField(
                                                    keyboardType: TextInputType.visiblePassword,
                                                    decoration: const InputDecoration(
                                                        labelText: "Senha",
                                                        hintText: "digite sua senha"
                                                    ),
                                                    controller: controllerEditarSenhaUsuario,
                                                  ),
                                                  TextField(
                                                    keyboardType: TextInputType.text,
                                                    decoration: const InputDecoration(
                                                        labelText: "Avatar",
                                                        hintText: "digite url do avatar"
                                                    ),
                                                    controller: controllerEditarAvatarUsuario,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancelar")
                                              ),
                                              ElevatedButton(
                                                  onPressed: (){
                                                    //editar usuario
                                                    _editarUsuario(
                                                      usuarios![index].id!,
                                                      controllerEditarCpfUsuario.text,
                                                      controllerEditarNomeUsuario.text,
                                                      controllerEditarEmailUsuario.text,
                                                      controllerEditarLoginUsuario.text,
                                                      controllerEditarSenhaUsuario.text,
                                                      controllerEditarAvatarUsuario.text
                                                    );

                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Salvar")
                                              ),
                                            ],
                                          );
                                        }
                                    );
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue,),
                                ),
                                IconButton(
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            content: Text("Deseja excluir o usuário ${usuarios![index].nome!}?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Não")
                                              ),
                                              TextButton(
                                                  onPressed: (){
                                                    _deletarUsuario(usuarios![index].id!);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Sim")
                                              ),
                                            ],
                                          );
                                        }
                                    );
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }else{
                    return Text("nenhum usuário");
                  }
                }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: const Text("Cadastrar Usuário"),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: "Cpf",
                              hintText: "digite seu cpf"
                          ),
                          controller: controllerAddCpfUsuario,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: "Nome",
                              hintText: "digite seu nome"
                          ),
                          controller: controllerAddNomeUsuario,
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: "E-mail",
                              hintText: "digite seu e-mail"
                          ),
                          controller: controllerAddEmailUsuario,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: "Login",
                              hintText: "digite seu login"
                          ),
                          controller: controllerAddLoginUsuario,
                        ),
                        TextField(
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                              labelText: "Senha",
                              hintText: "digite sua senha"
                          ),
                          controller: controllerAddSenhaUsuario,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: "Avatar",
                              hintText: "digite url do avatar"
                          ),
                          controller: controllerAddAvatarUsuario,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar")
                    ),
                    ElevatedButton(
                        onPressed: (){
                          //salvar novo usuario
                          bd.inserirUsuario(Usuario(
                              cpf: controllerAddCpfUsuario.text,
                              nome: controllerAddNomeUsuario.text,
                              email: controllerAddEmailUsuario.text,
                              login: controllerAddLoginUsuario.text,
                              senha: controllerAddSenhaUsuario.text,
                              avatar: controllerAddAvatarUsuario.text,
                          ));
                          controllerAddCpfUsuario.clear();
                          controllerAddNomeUsuario.clear();
                          controllerAddEmailUsuario.clear();
                          controllerAddLoginUsuario.clear();
                          controllerAddSenhaUsuario.clear();
                          controllerAddAvatarUsuario.clear();

                          _listarUsuarios();

                          Navigator.pop(context);
                        },
                        child: Text("Salvar")
                    ),
                  ],
                );
              }
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}