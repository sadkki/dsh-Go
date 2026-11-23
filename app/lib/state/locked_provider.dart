// Locked relay provider for the distributed build.
//
// Only the route definition is hard-coded here: provider id, display name,
// Base URL, protocol and model id. The real relay API Key is deliberately
// NOT in this file and NOT in the app source at all: anyone who gets the
// APK can extract a key baked into it.
//
// The Base URL below is the local proxy on the 225 host
// (~/workspace/dsh-proxy/proxy.js, http://127.0.0.1:18082/v1), not the
// relay itself. The proxy holds the real key server-side in
// /root/dsh-proxy/.env (0600, root only) and injects it when forwarding
// to https://api.hcnsec.cn. What is stored on an engine is only a
// limited guest/admin token for the proxy, never the real key. If that
// token leaks, change it in the proxy .env and restart the proxy; the
// real key is untouched.
//
// Provider id: verified on the 225 engine 2026-11-23 in
// /root/.dsh/profiles/web/cordis.patch.yml: "custom-deepseek4-1-flash",
// provider "custom-deepseek4-1-flash", baseURL "https://api.hcnsec.cn"
// (no "/v1" suffix as stored on the engine).
// Model id: the exact id the relay returns for its model. It is case
// sensitive. Verified on the 225 engine 2026-11-23 in the same file and in
// a saved session: "DeepSeek-V4.1-Flash" (capital V).
import 'package:dsh_client/dsh_client.dart';

import 'providers_state.dart';

/// Route id of the locked relay provider on the engine.
const lockedProviderId = 'custom-deepseek4-1-flash';

/// Display name shown for the locked provider.
const lockedProviderName = 'DeepSeek4.1-Flash';

/// Base URL of the local proxy on the 225 host, exactly as the guest
/// engine must call it. No "/v1" suffix and no trailing "/chat/completions":
/// the engine's Anthropic adapter appends "/v1/messages" itself, matching
/// the working provider on the 225 engine (baseURL https://api.hcnsec.cn).
/// The proxy forwards to the relay at https://api.hcnsec.cn.
const lockedBaseUrl = 'http://127.0.0.1:18082';

/// Model id as the relay returns it. Case sensitive. Verified on the 225
/// engine 2026-11-23: the stored model is "DeepSeek-V4.1-Flash" (capital V),
/// not "DeepSeek-v4.1-Flash".
const lockedModelId = 'DeepSeek-V4.1-Flash';

/// The only model selection this build offers.
const lockedModelSelection = ModelSelection(provider: lockedProviderId, model: lockedModelId);

bool isLockedProvider(String id) => id == lockedProviderId;

bool isLockedModelSelection(ModelSelection? selection) =>
    selection != null && selection.provider == lockedProviderId && selection.model == lockedModelId;

/// The provider profile to auto-seed on an engine that does not have the
/// locked route yet. No key is attached: the key must already be stored on
/// that engine. Callers must not put a key in this draft.
/// Protocol is anthropic-messages, matching the working provider on the
/// 225 engine (/root/.dsh/profiles/web/cordis.patch.yml: api:
/// anthropic-messages, baseURL https://api.hcnsec.cn). The proxy at
/// lockedBaseUrl forwards both /v1/messages and /v1/chat/completions.
ProviderDraft lockedProviderDraft() => ProviderDraft(
  name: lockedProviderName,
  api: ProviderApi.anthropicMessages,
  baseUrl: lockedBaseUrl,
  models: const [ProviderModelSpec(id: lockedModelId, name: lockedModelId)],
);
