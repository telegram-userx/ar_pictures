part of 'ar_data_loader_screen.dart';

class _Screen extends StatefulWidget {
  final PhotoAlbumEntity? photoAlbum;

  const _Screen({
    required this.photoAlbum,
  });

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  late final List<ReactionDisposer> _disposers;
  bool hasErrors = false;

  @override
  void initState() {
    _disposers = [
      reaction((_) => Provider.of<ArDataLoaderStore>(context, listen: false).isDownloadSuccess, (bool isSuccess) {
        if (isSuccess) {
          sl<AppRouter>().router.replace(AppRoutes.arJsWebView, extra: widget.photoAlbum?.id ?? '');
        }
      }),
    ];

    if (Provider.of<ArDataLoaderStore>(context, listen: false).photoAlbum?.isFullyDownloaded ?? false) {
      sl<AppRouter>().router.replace(
            AppRoutes.arJsWebView,
            extra: Provider.of<ArDataLoaderStore>(context, listen: false).photoAlbum?.id ?? '',
          );
    }

    super.initState();
  }

  @override
  void dispose() {
    for (final disposer in _disposers) {
      disposer();
    }

    super.dispose();
  }

  _onDownload(BuildContext context) async {
    try {
      await Provider.of<ArDataLoaderStore>(context, listen: false).startDownloading();
    } catch (error, stackTrace) {
      Logger.e(error, stackTrace);

      setState(() {
        hasErrors = true;
      });
    } finally {
      if (context.mounted) {
        Provider.of<ArDataLoaderStore>(context, listen: false).setIsDownloading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Observer(builder: (_) {
                  if (hasErrors) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.translations.somethingWentWrong,
                            style: context.textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 50,
                            child: Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text(
                                  'Ok',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (Provider.of<ArDataLoaderStore>(context, listen: false).isDownloading) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.translations.downloadInProgress(
                            total: Provider.of<ArDataLoaderStore>(context, listen: false)
                                .totalSizeInMegaBytes
                                .toStringAsFixed(2),
                            received: Provider.of<ArDataLoaderStore>(context, listen: false)
                                .downloadProgressTotal
                                .toStringAsFixed(2),
                          ),
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleLarge,
                        ),
                        Space.v20,
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.translations.areYouSureDownload(
                            megabytes: Provider.of<ArDataLoaderStore>(context, listen: false)
                                .totalSizeInMegaBytes
                                .toStringAsFixed(2),
                          ),
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleLarge,
                        ),
                        Space.v20,
                        SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: Text(context.translations.cancel),
                                ),
                              ),
                              Space.h20,
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _onDownload(context),
                                  child: Text(context.translations.download),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: SizedBox(
                height: 40,
                width: 40,
                child: IconButton(
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
