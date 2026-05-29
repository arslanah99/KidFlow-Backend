export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          extensions?: Json
          operationName?: string
          query?: string
          variables?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      audit_events: {
        Row: {
          action: string
          actor_classroom_device_session_id: string | null
          actor_staff_profile_id: string | null
          actor_type: Database["public"]["Enums"]["audit_actor_type"]
          actor_user_id: string | null
          centre_id: string | null
          created_at: string
          id: string
          metadata: Json
          org_id: string | null
          resource_id: string | null
          resource_type: string
        }
        Insert: {
          action: string
          actor_classroom_device_session_id?: string | null
          actor_staff_profile_id?: string | null
          actor_type: Database["public"]["Enums"]["audit_actor_type"]
          actor_user_id?: string | null
          centre_id?: string | null
          created_at?: string
          id?: string
          metadata?: Json
          org_id?: string | null
          resource_id?: string | null
          resource_type: string
        }
        Update: {
          action?: string
          actor_classroom_device_session_id?: string | null
          actor_staff_profile_id?: string | null
          actor_type?: Database["public"]["Enums"]["audit_actor_type"]
          actor_user_id?: string | null
          centre_id?: string | null
          created_at?: string
          id?: string
          metadata?: Json
          org_id?: string | null
          resource_id?: string | null
          resource_type?: string
        }
        Relationships: [
          {
            foreignKeyName: "audit_events_actor_classroom_device_session_id_fkey"
            columns: ["actor_classroom_device_session_id"]
            isOneToOne: false
            referencedRelation: "classroom_device_sessions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "audit_events_actor_staff_profile_id_fkey"
            columns: ["actor_staff_profile_id"]
            isOneToOne: false
            referencedRelation: "staff_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "audit_events_actor_user_id_fkey"
            columns: ["actor_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "audit_events_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "audit_events_centre_org_fk"
            columns: ["centre_id", "org_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id", "org_id"]
          },
          {
            foreignKeyName: "audit_events_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
      centre_memberships: {
        Row: {
          centre_id: string
          created_at: string
          created_by: string | null
          id: string
          org_id: string
          role: Database["public"]["Enums"]["app_role"]
          status: Database["public"]["Enums"]["membership_status"]
          updated_at: string
          user_id: string
        }
        Insert: {
          centre_id: string
          created_at?: string
          created_by?: string | null
          id?: string
          org_id: string
          role: Database["public"]["Enums"]["app_role"]
          status?: Database["public"]["Enums"]["membership_status"]
          updated_at?: string
          user_id: string
        }
        Update: {
          centre_id?: string
          created_at?: string
          created_by?: string | null
          id?: string
          org_id?: string
          role?: Database["public"]["Enums"]["app_role"]
          status?: Database["public"]["Enums"]["membership_status"]
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "centre_memberships_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "centre_memberships_centre_org_fk"
            columns: ["centre_id", "org_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id", "org_id"]
          },
          {
            foreignKeyName: "centre_memberships_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "centre_memberships_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "centre_memberships_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      centres: {
        Row: {
          address_line1: string | null
          address_line2: string | null
          capacity: number | null
          city: string | null
          country: string
          created_at: string
          email: string | null
          id: string
          license_number: string | null
          name: string
          org_id: string
          phone: string | null
          postal_code: string | null
          province: string | null
          slug: string
          status: Database["public"]["Enums"]["centre_status"]
          timezone: string
          updated_at: string
        }
        Insert: {
          address_line1?: string | null
          address_line2?: string | null
          capacity?: number | null
          city?: string | null
          country?: string
          created_at?: string
          email?: string | null
          id?: string
          license_number?: string | null
          name: string
          org_id: string
          phone?: string | null
          postal_code?: string | null
          province?: string | null
          slug: string
          status?: Database["public"]["Enums"]["centre_status"]
          timezone?: string
          updated_at?: string
        }
        Update: {
          address_line1?: string | null
          address_line2?: string | null
          capacity?: number | null
          city?: string | null
          country?: string
          created_at?: string
          email?: string | null
          id?: string
          license_number?: string | null
          name?: string
          org_id?: string
          phone?: string | null
          postal_code?: string | null
          province?: string | null
          slug?: string
          status?: Database["public"]["Enums"]["centre_status"]
          timezone?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "centres_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
      child_guardians: {
        Row: {
          can_message_staff: boolean
          can_view_billing: boolean
          can_view_messages: boolean
          can_view_photos: boolean
          can_view_profile: boolean
          can_view_reports: boolean
          centre_id: string
          child_id: string
          created_at: string
          guardian_profile_id: string
          id: string
          is_authorized_pickup: boolean
          is_emergency_contact: boolean
          is_primary: boolean
          org_id: string
          relationship: Database["public"]["Enums"]["guardian_relationship"]
          status: Database["public"]["Enums"]["record_status"]
          updated_at: string
        }
        Insert: {
          can_message_staff?: boolean
          can_view_billing?: boolean
          can_view_messages?: boolean
          can_view_photos?: boolean
          can_view_profile?: boolean
          can_view_reports?: boolean
          centre_id: string
          child_id: string
          created_at?: string
          guardian_profile_id: string
          id?: string
          is_authorized_pickup?: boolean
          is_emergency_contact?: boolean
          is_primary?: boolean
          org_id: string
          relationship?: Database["public"]["Enums"]["guardian_relationship"]
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Update: {
          can_message_staff?: boolean
          can_view_billing?: boolean
          can_view_messages?: boolean
          can_view_photos?: boolean
          can_view_profile?: boolean
          can_view_reports?: boolean
          centre_id?: string
          child_id?: string
          created_at?: string
          guardian_profile_id?: string
          id?: string
          is_authorized_pickup?: boolean
          is_emergency_contact?: boolean
          is_primary?: boolean
          org_id?: string
          relationship?: Database["public"]["Enums"]["guardian_relationship"]
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "child_guardians_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "child_guardians_child_id_fkey"
            columns: ["child_id"]
            isOneToOne: false
            referencedRelation: "children"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "child_guardians_child_scope_fk"
            columns: ["child_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "children"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "child_guardians_guardian_profile_id_fkey"
            columns: ["guardian_profile_id"]
            isOneToOne: false
            referencedRelation: "guardian_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "child_guardians_guardian_scope_fk"
            columns: ["guardian_profile_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "guardian_profiles"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "child_guardians_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
      children: {
        Row: {
          centre_id: string
          created_at: string
          current_classroom_id: string | null
          date_of_birth: string | null
          deactivated_at: string | null
          deleted_at: string | null
          first_name: string
          graduated_at: string | null
          id: string
          last_name: string
          org_id: string
          preferred_name: string | null
          status: Database["public"]["Enums"]["child_status"]
          updated_at: string
        }
        Insert: {
          centre_id: string
          created_at?: string
          current_classroom_id?: string | null
          date_of_birth?: string | null
          deactivated_at?: string | null
          deleted_at?: string | null
          first_name: string
          graduated_at?: string | null
          id?: string
          last_name: string
          org_id: string
          preferred_name?: string | null
          status?: Database["public"]["Enums"]["child_status"]
          updated_at?: string
        }
        Update: {
          centre_id?: string
          created_at?: string
          current_classroom_id?: string | null
          date_of_birth?: string | null
          deactivated_at?: string | null
          deleted_at?: string | null
          first_name?: string
          graduated_at?: string | null
          id?: string
          last_name?: string
          org_id?: string
          preferred_name?: string | null
          status?: Database["public"]["Enums"]["child_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "children_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "children_centre_org_fk"
            columns: ["centre_id", "org_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id", "org_id"]
          },
          {
            foreignKeyName: "children_current_classroom_id_fkey"
            columns: ["current_classroom_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "children_current_classroom_scope_fk"
            columns: ["current_classroom_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "children_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
      classroom_child_enrollments: {
        Row: {
          centre_id: string
          child_id: string
          classroom_id: string
          created_at: string
          ends_on: string | null
          id: string
          org_id: string
          starts_on: string
          status: Database["public"]["Enums"]["record_status"]
          updated_at: string
        }
        Insert: {
          centre_id: string
          child_id: string
          classroom_id: string
          created_at?: string
          ends_on?: string | null
          id?: string
          org_id: string
          starts_on: string
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Update: {
          centre_id?: string
          child_id?: string
          classroom_id?: string
          created_at?: string
          ends_on?: string | null
          id?: string
          org_id?: string
          starts_on?: string
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "classroom_child_enrollments_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_child_enrollments_child_id_fkey"
            columns: ["child_id"]
            isOneToOne: false
            referencedRelation: "children"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_child_enrollments_child_scope_fk"
            columns: ["child_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "children"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "classroom_child_enrollments_classroom_id_fkey"
            columns: ["classroom_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_child_enrollments_classroom_scope_fk"
            columns: ["classroom_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "classroom_child_enrollments_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
      classroom_child_movements: {
        Row: {
          centre_id: string
          child_id: string
          created_at: string
          from_classroom_id: string | null
          id: string
          moved_at: string
          moved_by_session_id: string | null
          moved_by_staff_profile_id: string | null
          moved_by_user_id: string | null
          org_id: string
          reason: string | null
          to_classroom_id: string
        }
        Insert: {
          centre_id: string
          child_id: string
          created_at?: string
          from_classroom_id?: string | null
          id?: string
          moved_at?: string
          moved_by_session_id?: string | null
          moved_by_staff_profile_id?: string | null
          moved_by_user_id?: string | null
          org_id: string
          reason?: string | null
          to_classroom_id: string
        }
        Update: {
          centre_id?: string
          child_id?: string
          created_at?: string
          from_classroom_id?: string | null
          id?: string
          moved_at?: string
          moved_by_session_id?: string | null
          moved_by_staff_profile_id?: string | null
          moved_by_user_id?: string | null
          org_id?: string
          reason?: string | null
          to_classroom_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "classroom_child_movements_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_child_movements_child_id_fkey"
            columns: ["child_id"]
            isOneToOne: false
            referencedRelation: "children"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_child_movements_child_scope_fk"
            columns: ["child_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "children"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "classroom_child_movements_from_classroom_id_fkey"
            columns: ["from_classroom_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_child_movements_from_classroom_scope_fk"
            columns: ["from_classroom_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "classroom_child_movements_moved_by_session_id_fkey"
            columns: ["moved_by_session_id"]
            isOneToOne: false
            referencedRelation: "classroom_device_sessions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_child_movements_moved_by_staff_profile_id_fkey"
            columns: ["moved_by_staff_profile_id"]
            isOneToOne: false
            referencedRelation: "staff_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_child_movements_moved_by_user_id_fkey"
            columns: ["moved_by_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_child_movements_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_child_movements_session_scope_fk"
            columns: ["moved_by_session_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "classroom_device_sessions"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "classroom_child_movements_to_classroom_id_fkey"
            columns: ["to_classroom_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_child_movements_to_classroom_scope_fk"
            columns: ["to_classroom_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
        ]
      }
      classroom_device_sessions: {
        Row: {
          centre_id: string
          classroom_id: string
          closed_at: string | null
          created_at: string
          device_name: string | null
          expires_at: string | null
          id: string
          opened_at: string
          opened_by_user_id: string | null
          org_id: string
          session_label: string | null
          status: Database["public"]["Enums"]["classroom_session_status"]
          updated_at: string
        }
        Insert: {
          centre_id: string
          classroom_id: string
          closed_at?: string | null
          created_at?: string
          device_name?: string | null
          expires_at?: string | null
          id?: string
          opened_at?: string
          opened_by_user_id?: string | null
          org_id: string
          session_label?: string | null
          status?: Database["public"]["Enums"]["classroom_session_status"]
          updated_at?: string
        }
        Update: {
          centre_id?: string
          classroom_id?: string
          closed_at?: string | null
          created_at?: string
          device_name?: string | null
          expires_at?: string | null
          id?: string
          opened_at?: string
          opened_by_user_id?: string | null
          org_id?: string
          session_label?: string | null
          status?: Database["public"]["Enums"]["classroom_session_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "classroom_device_sessions_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_device_sessions_classroom_id_fkey"
            columns: ["classroom_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_device_sessions_classroom_scope_fk"
            columns: ["classroom_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "classroom_device_sessions_opened_by_user_id_fkey"
            columns: ["opened_by_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_device_sessions_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
      classroom_staff_assignments: {
        Row: {
          centre_id: string
          classroom_id: string
          created_at: string
          ends_on: string | null
          id: string
          is_default: boolean
          org_id: string
          staff_profile_id: string
          starts_on: string | null
          status: Database["public"]["Enums"]["record_status"]
          updated_at: string
        }
        Insert: {
          centre_id: string
          classroom_id: string
          created_at?: string
          ends_on?: string | null
          id?: string
          is_default?: boolean
          org_id: string
          staff_profile_id: string
          starts_on?: string | null
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Update: {
          centre_id?: string
          classroom_id?: string
          created_at?: string
          ends_on?: string | null
          id?: string
          is_default?: boolean
          org_id?: string
          staff_profile_id?: string
          starts_on?: string | null
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "classroom_staff_assignments_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_assignments_classroom_id_fkey"
            columns: ["classroom_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_assignments_classroom_scope_fk"
            columns: ["classroom_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "classroom_staff_assignments_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_assignments_staff_profile_id_fkey"
            columns: ["staff_profile_id"]
            isOneToOne: false
            referencedRelation: "staff_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_assignments_staff_scope_fk"
            columns: ["staff_profile_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "staff_profiles"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
        ]
      }
      classroom_staff_movements: {
        Row: {
          centre_id: string
          created_at: string
          from_classroom_id: string | null
          id: string
          moved_at: string
          moved_by_session_id: string | null
          moved_by_staff_profile_id: string | null
          moved_by_user_id: string | null
          org_id: string
          reason: string | null
          staff_profile_id: string
          to_classroom_id: string
        }
        Insert: {
          centre_id: string
          created_at?: string
          from_classroom_id?: string | null
          id?: string
          moved_at?: string
          moved_by_session_id?: string | null
          moved_by_staff_profile_id?: string | null
          moved_by_user_id?: string | null
          org_id: string
          reason?: string | null
          staff_profile_id: string
          to_classroom_id: string
        }
        Update: {
          centre_id?: string
          created_at?: string
          from_classroom_id?: string | null
          id?: string
          moved_at?: string
          moved_by_session_id?: string | null
          moved_by_staff_profile_id?: string | null
          moved_by_user_id?: string | null
          org_id?: string
          reason?: string | null
          staff_profile_id?: string
          to_classroom_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "classroom_staff_movements_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_movements_from_classroom_id_fkey"
            columns: ["from_classroom_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_movements_from_classroom_scope_fk"
            columns: ["from_classroom_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "classroom_staff_movements_moved_by_session_id_fkey"
            columns: ["moved_by_session_id"]
            isOneToOne: false
            referencedRelation: "classroom_device_sessions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_movements_moved_by_staff_profile_id_fkey"
            columns: ["moved_by_staff_profile_id"]
            isOneToOne: false
            referencedRelation: "staff_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_movements_moved_by_user_id_fkey"
            columns: ["moved_by_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_movements_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_movements_session_scope_fk"
            columns: ["moved_by_session_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "classroom_device_sessions"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "classroom_staff_movements_staff_profile_id_fkey"
            columns: ["staff_profile_id"]
            isOneToOne: false
            referencedRelation: "staff_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_movements_staff_scope_fk"
            columns: ["staff_profile_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "staff_profiles"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "classroom_staff_movements_to_classroom_id_fkey"
            columns: ["to_classroom_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classroom_staff_movements_to_classroom_scope_fk"
            columns: ["to_classroom_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
        ]
      }
      classrooms: {
        Row: {
          age_group: string | null
          capacity: number | null
          centre_id: string
          created_at: string
          id: string
          name: string
          org_id: string
          ratio_label: string | null
          slug: string
          status: Database["public"]["Enums"]["classroom_status"]
          updated_at: string
        }
        Insert: {
          age_group?: string | null
          capacity?: number | null
          centre_id: string
          created_at?: string
          id?: string
          name: string
          org_id: string
          ratio_label?: string | null
          slug: string
          status?: Database["public"]["Enums"]["classroom_status"]
          updated_at?: string
        }
        Update: {
          age_group?: string | null
          capacity?: number | null
          centre_id?: string
          created_at?: string
          id?: string
          name?: string
          org_id?: string
          ratio_label?: string | null
          slug?: string
          status?: Database["public"]["Enums"]["classroom_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "classrooms_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classrooms_centre_org_fk"
            columns: ["centre_id", "org_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id", "org_id"]
          },
          {
            foreignKeyName: "classrooms_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
      guardian_profiles: {
        Row: {
          auth_user_id: string | null
          centre_id: string
          created_at: string
          email: string | null
          first_name: string
          id: string
          last_name: string
          org_id: string
          phone: string | null
          status: Database["public"]["Enums"]["record_status"]
          updated_at: string
        }
        Insert: {
          auth_user_id?: string | null
          centre_id: string
          created_at?: string
          email?: string | null
          first_name: string
          id?: string
          last_name: string
          org_id: string
          phone?: string | null
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Update: {
          auth_user_id?: string | null
          centre_id?: string
          created_at?: string
          email?: string | null
          first_name?: string
          id?: string
          last_name?: string
          org_id?: string
          phone?: string | null
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "guardian_profiles_auth_user_id_fkey"
            columns: ["auth_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "guardian_profiles_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "guardian_profiles_centre_org_fk"
            columns: ["centre_id", "org_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id", "org_id"]
          },
          {
            foreignKeyName: "guardian_profiles_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
      member_permission_overrides: {
        Row: {
          allowed: boolean
          centre_id: string | null
          created_at: string
          created_by: string | null
          expires_at: string | null
          id: string
          org_id: string
          permission_definition_id: string
          reason: string | null
          updated_at: string
          user_id: string
        }
        Insert: {
          allowed: boolean
          centre_id?: string | null
          created_at?: string
          created_by?: string | null
          expires_at?: string | null
          id?: string
          org_id: string
          permission_definition_id: string
          reason?: string | null
          updated_at?: string
          user_id: string
        }
        Update: {
          allowed?: boolean
          centre_id?: string | null
          created_at?: string
          created_by?: string | null
          expires_at?: string | null
          id?: string
          org_id?: string
          permission_definition_id?: string
          reason?: string | null
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "member_permission_overrides_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "member_permission_overrides_centre_org_fk"
            columns: ["centre_id", "org_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id", "org_id"]
          },
          {
            foreignKeyName: "member_permission_overrides_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "member_permission_overrides_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "member_permission_overrides_permission_definition_id_fkey"
            columns: ["permission_definition_id"]
            isOneToOne: false
            referencedRelation: "permission_definitions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "member_permission_overrides_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      organization_memberships: {
        Row: {
          created_at: string
          created_by: string | null
          id: string
          org_id: string
          role: Database["public"]["Enums"]["app_role"]
          status: Database["public"]["Enums"]["membership_status"]
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          id?: string
          org_id: string
          role: Database["public"]["Enums"]["app_role"]
          status?: Database["public"]["Enums"]["membership_status"]
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          created_by?: string | null
          id?: string
          org_id?: string
          role?: Database["public"]["Enums"]["app_role"]
          status?: Database["public"]["Enums"]["membership_status"]
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "organization_memberships_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organization_memberships_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organization_memberships_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      organizations: {
        Row: {
          created_at: string
          default_country: string
          default_timezone: string
          id: string
          legal_name: string | null
          name: string
          slug: string
          status: Database["public"]["Enums"]["record_status"]
          updated_at: string
        }
        Insert: {
          created_at?: string
          default_country?: string
          default_timezone?: string
          id?: string
          legal_name?: string | null
          name: string
          slug: string
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Update: {
          created_at?: string
          default_country?: string
          default_timezone?: string
          id?: string
          legal_name?: string | null
          name?: string
          slug?: string
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Relationships: []
      }
      permission_definitions: {
        Row: {
          action: string
          code: string
          created_at: string
          description: string | null
          domain: string
          id: string
          risk_level: string
          surface: string
        }
        Insert: {
          action: string
          code: string
          created_at?: string
          description?: string | null
          domain: string
          id?: string
          risk_level?: string
          surface: string
        }
        Update: {
          action?: string
          code?: string
          created_at?: string
          description?: string | null
          domain?: string
          id?: string
          risk_level?: string
          surface?: string
        }
        Relationships: []
      }
      profiles: {
        Row: {
          avatar_path: string | null
          created_at: string
          display_name: string | null
          email: string
          first_name: string | null
          id: string
          last_name: string | null
          phone: string | null
          status: Database["public"]["Enums"]["record_status"]
          updated_at: string
        }
        Insert: {
          avatar_path?: string | null
          created_at?: string
          display_name?: string | null
          email: string
          first_name?: string | null
          id: string
          last_name?: string | null
          phone?: string | null
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Update: {
          avatar_path?: string | null
          created_at?: string
          display_name?: string | null
          email?: string
          first_name?: string | null
          id?: string
          last_name?: string | null
          phone?: string | null
          status?: Database["public"]["Enums"]["record_status"]
          updated_at?: string
        }
        Relationships: []
      }
      role_permissions: {
        Row: {
          allowed: boolean
          created_at: string
          id: string
          permission_definition_id: string
          role: Database["public"]["Enums"]["app_role"]
        }
        Insert: {
          allowed?: boolean
          created_at?: string
          id?: string
          permission_definition_id: string
          role: Database["public"]["Enums"]["app_role"]
        }
        Update: {
          allowed?: boolean
          created_at?: string
          id?: string
          permission_definition_id?: string
          role?: Database["public"]["Enums"]["app_role"]
        }
        Relationships: [
          {
            foreignKeyName: "role_permissions_permission_definition_id_fkey"
            columns: ["permission_definition_id"]
            isOneToOne: false
            referencedRelation: "permission_definitions"
            referencedColumns: ["id"]
          },
        ]
      }
      staff_profiles: {
        Row: {
          auth_user_id: string | null
          centre_id: string
          created_at: string
          default_classroom_id: string | null
          email: string | null
          first_name: string
          id: string
          last_name: string
          org_id: string
          phone: string | null
          preferred_name: string | null
          status: Database["public"]["Enums"]["staff_status"]
          title: string | null
          updated_at: string
        }
        Insert: {
          auth_user_id?: string | null
          centre_id: string
          created_at?: string
          default_classroom_id?: string | null
          email?: string | null
          first_name: string
          id?: string
          last_name: string
          org_id: string
          phone?: string | null
          preferred_name?: string | null
          status?: Database["public"]["Enums"]["staff_status"]
          title?: string | null
          updated_at?: string
        }
        Update: {
          auth_user_id?: string | null
          centre_id?: string
          created_at?: string
          default_classroom_id?: string | null
          email?: string | null
          first_name?: string
          id?: string
          last_name?: string
          org_id?: string
          phone?: string | null
          preferred_name?: string | null
          status?: Database["public"]["Enums"]["staff_status"]
          title?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "staff_profiles_auth_user_id_fkey"
            columns: ["auth_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "staff_profiles_centre_id_fkey"
            columns: ["centre_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "staff_profiles_centre_org_fk"
            columns: ["centre_id", "org_id"]
            isOneToOne: false
            referencedRelation: "centres"
            referencedColumns: ["id", "org_id"]
          },
          {
            foreignKeyName: "staff_profiles_default_classroom_id_fkey"
            columns: ["default_classroom_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "staff_profiles_default_classroom_scope_fk"
            columns: ["default_classroom_id", "org_id", "centre_id"]
            isOneToOne: false
            referencedRelation: "classrooms"
            referencedColumns: ["id", "org_id", "centre_id"]
          },
          {
            foreignKeyName: "staff_profiles_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      can_manage_centre_membership: {
        Args: {
          target_centre_id: string
          target_role: Database["public"]["Enums"]["app_role"]
        }
        Returns: boolean
      }
      can_message_for_child: {
        Args: { target_child_id: string }
        Returns: boolean
      }
      can_read_child: {
        Args: { target_child_id: string }
        Returns: boolean
      }
      can_read_child_billing: {
        Args: { target_child_id: string }
        Returns: boolean
      }
      can_read_child_photos: {
        Args: { target_child_id: string }
        Returns: boolean
      }
      can_read_child_reports: {
        Args: { target_child_id: string }
        Returns: boolean
      }
      citext: {
        Args: { "": boolean } | { "": string } | { "": unknown }
        Returns: string
      }
      citext_hash: {
        Args: { "": string }
        Returns: number
      }
      citextin: {
        Args: { "": unknown }
        Returns: string
      }
      citextout: {
        Args: { "": string }
        Returns: unknown
      }
      citextrecv: {
        Args: { "": unknown }
        Returns: string
      }
      citextsend: {
        Args: { "": string }
        Returns: string
      }
      current_user_id: {
        Args: Record<PropertyKey, never>
        Returns: string
      }
      has_permission: {
        Args: {
          permission_code: string
          target_centre_id?: string
          target_org_id: string
        }
        Returns: boolean
      }
      is_centre_member: {
        Args: {
          allowed_roles?: Database["public"]["Enums"]["app_role"][]
          target_centre_id: string
        }
        Returns: boolean
      }
      is_org_member: {
        Args: {
          allowed_roles?: Database["public"]["Enums"]["app_role"][]
          target_org_id: string
        }
        Returns: boolean
      }
      is_owner_director_admin: {
        Args: { target_centre_id: string }
        Returns: boolean
      }
    }
    Enums: {
      app_role:
        | "owner"
        | "director"
        | "admin"
        | "staff"
        | "guardian"
        | "support"
      audit_actor_type:
        | "auth_user"
        | "staff_profile"
        | "classroom_device_session"
        | "system"
      centre_status: "active" | "inactive" | "archived"
      child_status: "active" | "graduated" | "deactivated" | "deleted"
      classroom_session_status: "active" | "closed" | "expired"
      classroom_status: "active" | "inactive" | "archived"
      guardian_relationship:
        | "mother"
        | "father"
        | "parent"
        | "guardian"
        | "foster_parent"
        | "grandparent"
        | "relative"
        | "other"
      membership_status: "invited" | "active" | "suspended" | "removed"
      record_status: "active" | "inactive" | "archived" | "deleted"
      staff_status: "active" | "inactive" | "terminated" | "archived"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {
      app_role: ["owner", "director", "admin", "staff", "guardian", "support"],
      audit_actor_type: [
        "auth_user",
        "staff_profile",
        "classroom_device_session",
        "system",
      ],
      centre_status: ["active", "inactive", "archived"],
      child_status: ["active", "graduated", "deactivated", "deleted"],
      classroom_session_status: ["active", "closed", "expired"],
      classroom_status: ["active", "inactive", "archived"],
      guardian_relationship: [
        "mother",
        "father",
        "parent",
        "guardian",
        "foster_parent",
        "grandparent",
        "relative",
        "other",
      ],
      membership_status: ["invited", "active", "suspended", "removed"],
      record_status: ["active", "inactive", "archived", "deleted"],
      staff_status: ["active", "inactive", "terminated", "archived"],
    },
  },
} as const

