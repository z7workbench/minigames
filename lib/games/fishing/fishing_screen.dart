import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import 'fishing_config.dart';
import 'fishing_provider.dart';
import 'models/fishing_state.dart';

class FishingScreen extends ConsumerStatefulWidget {
  const FishingScreen({super.key});

  @override
  ConsumerState<FishingScreen> createState() => _FishingScreenState();
}

class _FishingScreenState extends ConsumerState<FishingScreen>
    with TickerProviderStateMixin {
  Ticker? _gameTicker;
  Duration _lastElapsed = Duration.zero;

  bool _isHoldingButton = false;
  double _blockVelocity = 0.0;

  static const double _blockUpSpeed = -0.5;
  static const double _blockDownSpeed = 0.6;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _gameTicker?.dispose();
    _gameTicker = null;
    super.dispose();
  }

  void _startMiniGameLoop() {
    _gameTicker?.dispose();
    _gameTicker = null;
    _lastElapsed = Duration.zero;
    _blockVelocity = 0.0;
    _gameTicker = createTicker(_onGameTick)..start();
  }

  void _stopMiniGameLoop() {
    _gameTicker?.stop();
    _gameTicker?.dispose();
    _gameTicker = null;
  }

  void _onGameTick(Duration elapsed) {
    final state = ref.read(fishingGameProvider);
    if (state.status != FishingStatus.miniGame) {
      _stopMiniGameLoop();
      return;
    }

    final deltaTime = _lastElapsed == Duration.zero
        ? FishingConfig.logicUpdateFrequency
        : (elapsed - _lastElapsed).inMilliseconds / 1000.0;
    _lastElapsed = elapsed;

    if (_isHoldingButton) {
      _blockVelocity = _blockUpSpeed;
    } else {
      _blockVelocity = _blockDownSpeed;
    }

    final currentY = ref.read(fishingGameProvider).powerBlockY;
    final newY = (currentY + _blockVelocity * deltaTime).clamp(0.05, 0.95);
    ref.read(fishingGameProvider.notifier).setPowerBlockY(newY);

    ref.read(fishingGameProvider.notifier).updateMiniGame(deltaTime);
  }

  void _onTap() {
    final status = ref.read(fishingGameProvider).status;
    if (status == FishingStatus.biting) {
      HapticFeedback.mediumImpact();
      ref.read(fishingGameProvider.notifier).onBiteClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fishingGameProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(fishingGameProvider, (prev, next) {
      if (prev?.status != next.status) {
        if (next.status == FishingStatus.biting) {
          HapticFeedback.heavyImpact();
        }

        if (next.status == FishingStatus.miniGame) {
          _startMiniGameLoop();
        } else {
          _stopMiniGameLoop();
          _isHoldingButton = false;
        }
      }
    });

    return Scaffold(
      backgroundColor: FishingColors.waterDeep,
      appBar: AppBar(
        title: Text(l10n.game_fishing),
        backgroundColor: context.themePrimary,
        foregroundColor: context.themeOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _stopMiniGameLoop();
              ref.read(fishingGameProvider.notifier).reset();
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                FishingColors.waterSurface,
                FishingColors.waterDeep,
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: _buildBody(state, l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(FishingState state, AppLocalizations l10n) {
    switch (state.status) {
      case FishingStatus.idle:
        return _buildIdleUI(state, l10n);
      case FishingStatus.waiting:
        return _buildWaitingUI(state, l10n);
      case FishingStatus.biting:
        return _buildBiteIndicator(state, l10n);
      case FishingStatus.miniGame:
        return _buildMiniGameBody(state, l10n);
      case FishingStatus.success:
        return _buildSuccessOverlay(state, l10n);
      case FishingStatus.failed:
        return _buildFailedOverlay(state, l10n);
    }
  }

  Widget _buildBiteIndicator(FishingState state, AppLocalizations l10n) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.9, end: 1.1),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      color: FishingColors.hintYellow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.pan_tool, color: Colors.black87, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          l10n.fishing_tapNow,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: state.biteTimeLeft / FishingConfig.biteWindowSeconds,
                    strokeWidth: 8,
                    backgroundColor: Colors.white30,
                    valueColor: const AlwaysStoppedAnimation(FishingColors.bobberNormal),
                  ),
                  Text(
                    state.biteTimeLeft.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
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

  Widget _buildMiniGameBody(FishingState state, AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        final isLandscape = availableWidth > availableHeight;

        final fishY = state.fishY;
        final blockY = state.powerBlockY;
        final bool isAligned = (blockY - fishY).abs() < 0.15;

        if (isLandscape) {
          return _buildMiniGameLandscape(state, l10n, availableWidth, availableHeight, fishY, blockY, isAligned);
        }
        return _buildMiniGamePortrait(state, l10n, availableWidth, availableHeight, fishY, blockY, isAligned);
      },
    );
  }

  Widget _buildMiniGamePortrait(
    FishingState state,
    AppLocalizations l10n,
    double availableWidth,
    double availableHeight,
    double fishY,
    double blockY,
    bool isAligned,
  ) {
    final trackWidth = availableWidth * 0.15;
    final trackHeight = availableHeight * 0.35;
    final blockHeight = trackHeight * 0.10;
    final blockWidth = trackWidth * 1.2;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: availableHeight),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFishTypeIndicator(state, l10n),
              const SizedBox(height: 20),
              SizedBox(
                width: trackWidth + 50,
                height: trackHeight,
                child: _buildTrack(
                  trackWidth + 50,
                  trackHeight,
                  blockWidth,
                  blockHeight,
                  fishY,
                  blockY,
                  true,
                  state.fishConfig.color,
                ),
              ),
              const SizedBox(height: 12),
              _buildAlignmentLabel(isAligned, l10n),
              const SizedBox(height: 8),
              _buildProgressBar(state, availableWidth),
              const SizedBox(height: 6),
              _buildTimerText(state),
              const SizedBox(height: 16),
              _buildControlButton(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniGameLandscape(
    FishingState state,
    AppLocalizations l10n,
    double availableWidth,
    double availableHeight,
    double fishY,
    double blockY,
    bool isAligned,
  ) {
    final trackWidth = availableWidth * 0.5;
    final trackHeight = availableHeight * 0.15;
    final blockWidth = trackHeight * 1.2;
    final blockHeight = trackHeight * 0.6;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFishTypeIndicator(state, l10n),
              const SizedBox(height: 24),
              SizedBox(
                width: trackWidth,
                height: trackHeight,
                child: _buildTrack(
                  trackWidth,
                  trackHeight,
                  blockWidth,
                  blockHeight,
                  fishY,
                  blockY,
                  false,
                  state.fishConfig.color,
                ),
              ),
              const SizedBox(height: 8),
              _buildAlignmentLabel(isAligned, l10n),
              const SizedBox(height: 8),
              _buildProgressBar(state, availableWidth * 0.5),
              const SizedBox(height: 4),
              _buildTimerText(state),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatsPanel(state, l10n),
            const SizedBox(height: 16),
            _buildControlButton(l10n),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildTrack(
    double width,
    double height,
    double blockW,
    double blockH,
    double fishPos,
    double blockPos,
    bool isVertical,
    Color fishColor,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white30, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                if (isVertical) ...[
                  Positioned(
                    left: 0,
                    right: 0,
                    top: blockPos * height - blockH / 2,
                    child: _buildPowerBlock(blockW, blockH),
                  ),
                  Positioned(
                    right: 8,
                    top: fishPos * height - 10,
                    child: _buildFishDot(fishColor),
                  ),
                ] else ...[
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: blockPos * width - blockW / 2,
                    child: _buildPowerBlockHorizontal(blockW, blockH),
                  ),
                  Positioned(
                    top: 4,
                    left: fishPos * width - 10,
                    child: _buildFishDot(fishColor),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (isVertical)
          Positioned(
            right: -18,
            top: fishPos * height - 9,
            child: const Icon(Icons.arrow_left, color: Colors.white, size: 18),
          )
        else
          Positioned(
            left: fishPos * width - 9,
            top: -18,
            child: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
          ),
      ],
    );
  }

  Widget _buildFishDot(Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Center(
        child: Icon(Icons.pets, size: 12, color: Colors.white),
      ),
    );
  }

  Widget _buildAlignmentLabel(bool isAligned, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAligned ? Colors.green.withAlpha(200) : Colors.red.withAlpha(150),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isAligned ? l10n.fishing_aligned : l10n.fishing_moveToFish,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimerText(FishingState state) {
    return Text(
      '${state.miniGameTimeLeft.toStringAsFixed(1)}s',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFishTypeIndicator(FishingState state, AppLocalizations l10n) {
    final fishConfig = state.fishConfig;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: fishConfig.color.withAlpha(200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pets, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            fishConfig.localizedName(l10n),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerBlock(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Widget _buildPowerBlockHorizontal(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Widget _buildControlButton(AppLocalizations l10n) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final size = isLandscape ? 100.0 : 100.0;

    return GestureDetector(
      onTapDown: (_) {
        if (mounted) setState(() => _isHoldingButton = true);
      },
      onTapUp: (_) {
        if (mounted) setState(() => _isHoldingButton = false);
      },
      onTapCancel: () {
        if (mounted) setState(() => _isHoldingButton = false);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _isHoldingButton
              ? const Color(0xFFAD1457)
              : const Color(0xFFE91E63),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE91E63).withAlpha(150),
              blurRadius: 16,
              spreadRadius: 4,
            ),
          ],
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isHoldingButton ? Icons.arrow_upward : Icons.pause,
              color: Colors.white,
              size: isLandscape ? 40 : 36,
            ),
            Text(
              _isHoldingButton ? l10n.fishing_up : l10n.fishing_hold,
              style: TextStyle(
                color: Colors.white,
                fontSize: isLandscape ? 12 : 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(FishingState state, double availableWidth) {
    final width = availableWidth * FishingConfig.progressBarWidth;
    return Container(
      width: width,
      height: FishingConfig.progressBarHeight,
      decoration: BoxDecoration(
        color: FishingColors.progressBarBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: state.progressPercent,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [FishingColors.progressBarFill, Color(0xFF8BC34A)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Center(
            child: Text(
              '${state.progress.toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingUI(FishingState state, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.water,
            size: 80,
            color: Colors.white.withAlpha(179),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.fishing_waitingForFish,
            style: TextStyle(
              color: Colors.white.withAlpha(230),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdleUI(FishingState state, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.phishing,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.fishing_throwRod,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
const SizedBox(height: 32),
          _buildThrowButton(state, l10n),
          const SizedBox(height: 24),
          _buildStatsPanel(state, l10n),
        ],
      ),
    );
  }

  Widget _buildThrowButton(FishingState state, AppLocalizations l10n) {
    return ElevatedButton.icon(
      onPressed: () => ref.read(fishingGameProvider.notifier).throwRod(),
      icon: const Icon(Icons.phishing, color: Colors.white),
      label: Text(
        l10n.fishing_cast,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: FishingColors.bobberNormal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }

  Widget _buildStatsPanel(FishingState state, AppLocalizations l10n) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      padding: EdgeInsets.all(isLandscape ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatItem(l10n.fishing_caughtStat, state.fishCaught.toString(), FishingColors.successGreen, isLandscape ? 18 : 24),
          SizedBox(width: isLandscape ? 12 : 20),
          _buildStatItem(l10n.fishing_escapedStat, state.fishEscaped.toString(), FishingColors.failRed, isLandscape ? 18 : 24),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, [double fontSize = 24]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessOverlay(FishingState state, AppLocalizations l10n) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 80,
              color: FishingColors.successGreen,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.fishing_caught,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.fishConfig.localizedName(l10n),
              style: TextStyle(
                color: state.fishConfig.color,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatsPanel(state, l10n),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => ref.read(fishingGameProvider.notifier).throwRod(),
              icon: const Icon(Icons.replay),
              label: Text(l10n.fishing_continue),
              style: ElevatedButton.styleFrom(
                backgroundColor: FishingColors.successGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailedOverlay(FishingState state, AppLocalizations l10n) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cancel,
              size: 80,
              color: FishingColors.failRed,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.fishing_escaped,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatsPanel(state, l10n),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => ref.read(fishingGameProvider.notifier).throwRod(),
              icon: const Icon(Icons.replay),
              label: Text(l10n.fishing_continue),
              style: ElevatedButton.styleFrom(
                backgroundColor: FishingColors.failRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
