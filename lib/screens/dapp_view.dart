import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/services/wallet/wallet_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web3_webview/flutter_web3_webview.dart';
import 'package:get_it/get_it.dart';
import 'dart:math' as math;

class DappView extends StatefulWidget {
  final String initialDappUrl, name;
  const DappView({Key? key, required this.initialDappUrl, required this.name})
      : super(key: key);

  @override
  State<DappView> createState() => _DappViewState();
}

class _DappViewState extends State<DappView> with TickerProviderStateMixin {
  late TabController _tabController;
  final Map<GlobalKey<_WebViewTabState>, WebViewTab> _tabsMap = {};
  Map<int, String> _tabUrls = {}; // Keep this to maintain URL history

  late WalletBloc walletBloc;
  late WalletService walletService;
  late int chainId;
  late String rpc;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of<WalletBloc>(context);
    walletService = GetIt.I<WalletService>();
    chainId = int.parse(walletBloc.selectedChain.chainId.split(':').last);
    rpc = walletBloc.selectedChain.rpc;

    _initializeTabController();
    _addNewTab(widget.initialDappUrl);
    searchController.text = widget.initialDappUrl;

    final newChain = walletBloc.chains.firstWhere(
      (chain) => int.parse(chain.chainId.split(':').last) == 202424,
      orElse: () => throw Exception('Unsupported chain'),
    );

    walletBloc.add(ChangeChain(chain: newChain));
  }

  void _initializeTabController() {
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _handleTabChange();
      }
    });
  }

  void _handleTabChange() {
    if (_tabController.index >= 0 && _tabController.index < _tabsMap.length) {
      setState(() {
        if (_tabUrls.containsKey(_tabController.index)) {
          searchController.text = _tabUrls[_tabController.index]!;
        }
      });
    }
  }

  String _getDomainFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      String domain = uri.host;
      if (domain.startsWith('www.')) {
        domain = domain.substring(4);
      }
      return domain;
    } catch (e) {
      return 'New Tab';
    }
  }

  void _addNewTab(String url) {
    final newTabIndex = _tabsMap.length;
    final newKey = GlobalKey<_WebViewTabState>();

    setState(() {
      final newWebViewTab = WebViewTab(
        key: newKey,
        url: url,
        onPageStarted: (index, title) => _updateTabTitle(index, url),
        onCreateWindow: _handleCreateWindow,
        onUrlChanged: (String newUrl) {
          _onUrlChanged(newUrl, newTabIndex);
        },
        walletBloc: walletBloc,
        chainId: 56,
        rpc: 'https://bsc-dataseed1.bnbchain.org',
        title: url,
      );

      _tabsMap[newKey] = newWebViewTab;
      _tabUrls[newTabIndex] = url;

      // Update TabController
      _tabController.removeListener(_handleTabChange);
      _tabController.dispose();

      _tabController = TabController(
        length: _tabsMap.length,
        vsync: this,
        initialIndex: newTabIndex,
      );

      _tabController.addListener(_handleTabChange);
      searchController.text = url;
    });

    // Ensure we switch to the new tab after the state update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _tabController.animateTo(
          newTabIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onUrlChanged(String url, int tabIndex) {
    setState(() {
      _tabUrls[tabIndex] = url;
      if (_tabController.index == tabIndex) {
        searchController.text = url;
      }
    });
  }

  void _updateTabTitle(int index, String url) {
    setState(() {});
  }

  Future<bool> _handleCreateWindow(
      CreateWindowAction createWindowAction) async {
    final url = createWindowAction.request.url?.toString() ?? 'about:blank';
    _addNewTab(url);
    return true;
  }

  void performSearch(String query, int tabIndex) {
    final keys = _tabsMap.keys.toList();
    if (keys.isNotEmpty && tabIndex < keys.length) {
      String finalUrl;
      if (Uri.parse(query).isAbsolute) {
        finalUrl = query;
      } else {
        finalUrl = 'https://duckduckgo.com/?q=${Uri.encodeComponent(query)}';
      }

      keys[tabIndex].currentState?.loadUrl(finalUrl);
      _tabUrls[tabIndex] = finalUrl;
    }
  }

  void _closeCurrentTab() {
    if (_tabsMap.length <= 1) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      final currentIndex = _tabController.index;
      final keys = _tabsMap.keys.toList();

      // Remove current tab
      _tabsMap.remove(keys[currentIndex]);

      // Update URLs
      Map<int, String> newTabUrls = {};
      _tabUrls.forEach((key, value) {
        if (key < currentIndex) {
          newTabUrls[key] = value;
        } else if (key > currentIndex) {
          newTabUrls[key - 1] = value;
        }
      });
      _tabUrls = newTabUrls;

      // Update controller
      _tabController.removeListener(_handleTabChange);
      _tabController.dispose();

      final newIndex = math.min(currentIndex, _tabsMap.length - 1);
      _tabController = TabController(
        length: _tabsMap.length,
        vsync: this,
        initialIndex: newIndex,
      );

      _tabController.addListener(_handleTabChange);

      if (_tabUrls.containsKey(newIndex)) {
        searchController.text = _tabUrls[newIndex]!;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _tabController.animateTo(
            newIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  void _showTabsPage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tabs (${_tabsMap.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            _addNewTab('https://duckduckgo.com/');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _tabsMap.length,
                  itemBuilder: (context, index) {
                    _tabsMap.entries.elementAt(index);
                    final url = _tabUrls[index] ?? '';
                    final isCurrentTab = index == _tabController.index;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isCurrentTab ? Colors.grey[900] : Colors.grey[850],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.public, color: Colors.white),
                        title: Text(
                          _getDomainFromUrl(url),
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          url,
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          _tabController.index = index;
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _tabsMap.entries.map((entry) {
      final url = _tabUrls[_tabsMap.entries.toList().indexOf(entry)] ?? '';
      return Tab(text: _getDomainFromUrl(url));
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.black,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search or Type URL',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: const TextStyle(color: Colors.black),
                        onSubmitted: (query) =>
                            performSearch(query, _tabController.index),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: _tabsMap.values.toList(),
              ),
            ),
            // Bottom navigation bar
            Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      final keys = _tabsMap.keys.toList();
                      if (keys.isNotEmpty) {
                        keys[_tabController.index].currentState?.goBack();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    onPressed: () {
                      final keys = _tabsMap.keys.toList();
                      if (keys.isNotEmpty) {
                        keys[_tabController.index].currentState?.goForward();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      final keys = _tabsMap.keys.toList();
                      if (keys.isNotEmpty) {
                        final url = _tabUrls[_tabController.index];
                        if (url != null) {
                          keys[_tabController.index].currentState?.loadUrl(url);
                        }
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: _closeCurrentTab,
                  ),
                  TextButton.icon(
                    onPressed: _showTabsPage,
                    icon: const Icon(Icons.layers, color: Colors.white),
                    label: Text(
                      _tabsMap.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }
}

class WebViewTab extends StatefulWidget {
  final String url;
  final Function(int, String?) onPageStarted;
  final Function(String) onUrlChanged;
  final Future<bool> Function(CreateWindowAction) onCreateWindow;
  final WalletBloc walletBloc;
  final int chainId;
  final String rpc;
  final String title;

  const WebViewTab(
      {Key? key,
      required this.url,
      required this.onPageStarted,
      required this.onUrlChanged,
      required this.onCreateWindow,
      required this.walletBloc,
      required this.chainId,
      required this.rpc,
      required this.title})
      : super(key: key);

  @override
  _WebViewTabState createState() => _WebViewTabState();
}

class _WebViewTabState extends State<WebViewTab>
    with AutomaticKeepAliveClientMixin {
  InAppWebViewController? webViewController;
  bool isLoading = true; // Set initial loading state to true
  String _currentUrl = '';
  double loadingProgress = 0; // Add loading progress

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0 &&
                details.primaryVelocity!.abs() > 1000) {
              // Right swipe (go back) only if velocity is significant
              goBack();
            }
          },
          child: Web3Webview(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              verticalScrollBarEnabled: true,
              horizontalScrollBarEnabled: true,
              allowsInlineMediaPlayback: true,
              iframeAllowFullscreen: true,
              javaScriptEnabled: true,
              supportZoom: true,
              useOnDownloadStart: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
              useHybridComposition: true,
            ),
            gestureRecognizers: {
              Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
              ),
              Factory<HorizontalDragGestureRecognizer>(
                () => HorizontalDragGestureRecognizer(),
              ),
              Factory<LongPressGestureRecognizer>(
                () => LongPressGestureRecognizer(),
              ),
              Factory<ScaleGestureRecognizer>(
                () => ScaleGestureRecognizer(),
              ),
            },
            onWebViewCreated: (controller) {
              webViewController = controller;
              _setupWeb3Handlers(controller);
            },
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
                loadingProgress = 0;
              });
              widget.onPageStarted(0, url?.host);
              widget.onUrlChanged(url.toString());
            },
            onLoadStop: (controller, url) async {
              setState(() {
                isLoading = false;
              });
              widget.onUrlChanged(url.toString());
              await _injectEthereumProvider(controller);
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                loadingProgress = progress / 100;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async =>
                NavigationActionPolicy.ALLOW,
            onCreateWindow: (controller, createWindowAction) =>
                widget.onCreateWindow(createWindowAction),
            ethAccounts: _ethAccounts,
            ethChainId: _ethChainId,
            walletSwitchEthereumChain: _walletSwitchEthereumChain,
            settings: Web3Settings(
              eth: Web3EthSettings(
                chainId: widget.chainId,
              ),
            ),
          ),
        ),
        if (isLoading)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: loadingProgress > 0 ? loadingProgress : null,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 10),
                Text(
                  'Loading... ${(loadingProgress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void loadUrl(String url) {
    webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  }

  void goBack() {
    webViewController?.goBack();
  }

  void goForward() {
    webViewController?.goForward();
  }

  String getCurrentUrl() {
    return _currentUrl;
  }

  void _setupWeb3Handlers(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: 'requestAccounts',
      callback: (args) async {
        return await _requestAccounts();
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'getChainId',
      callback: (args) async {
        return await _ethChainId();
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'addEthereumChain',
      callback: (args) async {
        if (args.isNotEmpty) {
          final data = JsAddEthereumChain.fromJson(args[0]);
          return await _addEthereumChain(controller, data);
        }
        throw Exception('Invalid arguments for addEthereumChain');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'switchEthereumChain',
      callback: (args) async {
        if (args.isNotEmpty) {
          final data = JsAddEthereumChain.fromJson(args[0]);
          return await _switchEthereumChain(controller, data);
        }
        throw Exception('Invalid arguments for switchEthereumChain');
      },
    );
  }

  Future<void> _injectEthereumProvider(
      InAppWebViewController controller) async {
    final js = '''
      window.ethereum = {
        isMetaMask: true,
        chainId: '0x${widget.walletBloc.selectedChain.chainId.split(':').last}',
        networkVersion: '1',
        selectedAddress: '${widget.walletBloc.selectedAccount!.address}',
        request: async function(args) {
          if (args.method === 'eth_requestAccounts') {
            const accounts = await window.flutter_inappwebview.callHandler('requestAccounts');
            this.selectedAddress = accounts[0];
            return accounts;
          } else if (args.method === 'eth_chainId') {
            return await window.flutter_inappwebview.callHandler('getChainId');
          } else if (args.method === 'wallet_addEthereumChain') {
            return await window.flutter_inappwebview.callHandler('addEthereumChain', args.params[0]);
          } else if (args.method === 'wallet_switchEthereumChain') {
            return await window.flutter_inappwebview.callHandler('switchEthereumChain', args.params[0]);
          }
          // Handle other methods here
          throw new Error('Method not implemented');
        },
        on: function(eventName, callback) {
          // Implement event listeners
        },
        removeListener: function(eventName, callback) {
          // Implement removing event listeners
        },
      };
    ''';
    await controller.evaluateJavascript(source: js);
  }

  Future<List<String>> _requestAccounts() async {
    final selectedAccount = widget.walletBloc.selectedAccount;
    if (selectedAccount != null) {
      return [selectedAccount.address];
    } else {
      throw Exception('No account selected');
    }
  }

  Future<List<String>> _ethAccounts() async {
    final selectedAccount = widget.walletBloc.selectedAccount;
    return [selectedAccount!.address];
  }

  Future<int> _ethChainId() async {
    return widget.chainId;
  }

  Future<bool> _walletSwitchEthereumChain(JsAddEthereumChain data) async {
    final newChainId =
        int.parse(data.chainId!.replaceFirst('0x', ''), radix: 16);

    final newChain = widget.walletBloc.chains.firstWhere(
      (chain) => int.parse(chain.chainId.split(':').last) == newChainId,
      orElse: () => throw Exception('Unsupported chain'),
    );
    widget.walletBloc.add(ChangeChain(chain: newChain));
    // final newRpc = newChainId == 137 ? "https://1rpc.io/matic" : newChain.rpc;
    await _injectEthereumProvider(webViewController!);
    return true;
  }

  Future<String> _addEthereumChain(
      InAppWebViewController controller, JsAddEthereumChain data) async {
    try {
      final newChainId =
          int.parse(data.chainId!.replaceFirst('0x', ''), radix: 16);

      final newChain = widget.walletBloc.chains.firstWhere(
        (chain) => int.parse(chain.chainId.split(':').last) == newChainId,
        orElse: () => throw Exception('Unsupported chain'),
      );

      final newRpc = newChain.rpc;

      // Reinitialize the Ethereum provider with the new chain
      await _injectEthereumProvider(controller);

      return newRpc;
    } catch (e) {
      throw Exception('Failed to add Ethereum chain: ${e.toString()}');
    }
  }

  Future<String> _switchEthereumChain(
      InAppWebViewController controller, JsAddEthereumChain data) async {
    try {
      final newChainId =
          int.parse(data.chainId!.replaceFirst('0x', ''), radix: 16);

      final newChain = widget.walletBloc.chains.firstWhere(
        (chain) => int.parse(chain.chainId.split(':').last) == newChainId,
        orElse: () => throw Exception('Unsupported chain'),
      );

      widget.walletBloc.add(ChangeChain(chain: newChain));

      final newRpc = newChainId == 137 ? "https://1rpc.io/matic" : newChain.rpc;

      // Reinitialize the Ethereum provider with the new chain
      await _injectEthereumProvider(controller);
      return newRpc;
    } catch (e) {
      throw Exception('Failed to switch Ethereum chain: ${e.toString()}');
    }
  }
}
