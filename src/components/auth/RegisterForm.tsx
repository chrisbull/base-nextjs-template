'use client'

import { useState, useEffect } from 'react'
import {
  ClientSafeProvider,
  LiteralUnion,
  signIn,
  getProviders,
} from 'next-auth/react'
import {
  Button,
  VStack,
  Text,
  Input,
  Stack,
  Link,
  Separator,
  Icon,
} from '@chakra-ui/react'
import { PasswordInput } from '@/components/ui/password-input'
import { Field } from '@/components/ui/field'
import { getProviderColor, getProviderIcon } from '@/components/auth/utils'

export function RegisterForm() {
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState(false)
  const [providers, setProviders] = useState<Record<
    LiteralUnion<string>,
    ClientSafeProvider
  > | null>(null)

  useEffect(() => {
    const fetchProviders = async () => {
      const providersData = await getProviders()
      setProviders(providersData)
    }
    fetchProviders()
  }, [])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    setError('')

    // Basic validation
    if (!name || !email || !password || !confirmPassword) {
      setError('All fields are required')
      setIsLoading(false)
      return
    }

    if (password !== confirmPassword) {
      setError('Passwords do not match')
      setIsLoading(false)
      return
    }

    if (password.length < 6) {
      setError('Password must be at least 6 characters long')
      setIsLoading(false)
      return
    }

    try {
      const res = await fetch('/api/auth/register', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name,
          email,
          password,
        }),
      })

      const data = await res.json()

      if (res.ok) {
        setSuccess(true)
        // Auto sign in after successful registration
        await signIn('credentials', {
          email,
          password,
          redirect: false,
        })
        // Redirect to home page
        window.location.href = '/'
      } else {
        setError(data.error || 'Registration failed')
      }
    } catch {
      setError('An error occurred during registration')
    } finally {
      setIsLoading(false)
    }
  }

  if (success) {
    return (
      <VStack gap={4} w="full">
        <Text color="green.500">
          Registration successful! Signing you in...
        </Text>
      </VStack>
    )
  }

  const oauthProviders = providers
    ? Object.values(providers).filter(provider => provider.id !== 'credentials')
    : []

  return (
    <VStack gap={6} w="full">
      <form onSubmit={handleSubmit} style={{ width: '100%' }}>
        <Stack gap={4}>
          <Field label="Full Name">
            <Input
              type="text"
              placeholder="Full Name"
              value={name}
              onChange={e => setName(e.target.value)}
              required
            />
          </Field>

          <Field label="Email">
            <Input
              type="email"
              placeholder="Email"
              value={email}
              onChange={e => setEmail(e.target.value)}
              required
            />
          </Field>

          <Field label="Password">
            <PasswordInput
              placeholder="Password"
              value={password}
              onChange={e => setPassword(e.target.value)}
              required
            />
          </Field>

          <Field label="Confirm Password">
            <PasswordInput
              placeholder="Confirm Password"
              value={confirmPassword}
              onChange={e => setConfirmPassword(e.target.value)}
              required
            />
          </Field>

          {error && (
            <Text fontSize="sm" color="red.500" bg="red.50" p={2} rounded="md">
              {error}
            </Text>
          )}

          <Button type="submit" w="full" loading={isLoading}>
            Create Account
          </Button>
        </Stack>
      </form>

      <Text fontSize="sm" color="fg.muted">
        Already have an account?{' '}
        <Link
          href="/auth/signin"
          textDecoration="underline"
          fontWeight="semibold"
        >
          Sign in
        </Link>
      </Text>

      {/* OAuth Providers */}
      {oauthProviders.length > 0 && (
        <>
          <Separator />
          <VStack gap={4} w="full">
            <Text fontSize="sm" color="gray.600">
              Or continue with
            </Text>
            {oauthProviders.map(provider => {
              const IconComponent = getProviderIcon(provider.id)
              const colorPalette = getProviderColor(provider.id)

              return (
                <Button
                  key={provider.id}
                  onClick={() => signIn(provider.id)}
                  w="full"
                  colorPalette={colorPalette}
                  variant="outline"
                >
                  {IconComponent && <Icon as={IconComponent} me={2} />}
                  Sign in with {provider.name}
                </Button>
              )
            })}
          </VStack>
        </>
      )}
    </VStack>
  )
}
